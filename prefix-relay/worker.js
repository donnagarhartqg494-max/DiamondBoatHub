// DiamondBoatHub shared-prefix, owner-only chat, and server-presence relay (Cloudflare Worker + KV)
// Deploy with a KV namespace binding named PREFIXES.
// IMPORTANT: Executor clients cannot prove Roblox account ownership to this Worker.
// Treat records as unverified display data; do not use for permissions, moderation, or trust.
const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store"
};
const reply = (data, status = 200) =>
  new Response(JSON.stringify(data), { status, headers: cors });
const clean = (s, n) => String(s ?? "").replace(/[\u0000-\u001f\u007f<>]/g, "").trim().slice(0, n);
const validId = (s) => /^\d{1,20}$/.test(String(s ?? ""));
const validColor = (s) => /^#[0-9a-fA-F]{6}$/.test(String(s ?? ""));

export default {
  async fetch(request, env) {
    try {
    if (request.method === "OPTIONS") return new Response(null, { headers: cors });
    if (!env.PREFIXES) return reply({ error: "KV binding PREFIXES is missing" }, 500);
    const url = new URL(request.url);
    if (url.pathname === "/health" && request.method === "GET") return reply({ ok: true, service: "DiamondBoatHub Prefix Relay", version: 2 });

    // Shared GLOBAL CHAT. Messages are scoped to the Roblox place and expire after 24 hours.
    if (url.pathname === "/chat" && request.method === "GET") {
      const gameId = clean(url.searchParams.get("gameId"), 32);
      if (!gameId) return reply({ error: "gameId is required" }, 400);
      const listed = await env.PREFIXES.list({ prefix: "chat:" + gameId + ":", limit: 1000 });
      const messages = [];
      for (const key of listed.keys) {
        const raw = await env.PREFIXES.get(key.name);
        if (!raw) continue;
        try { messages.push(JSON.parse(raw)); } catch {}
      }
      messages.sort((a, b) => Number(a.createdAt || 0) - Number(b.createdAt || 0));
      return reply({ ok: true, messages: messages.slice(-60) });
    }

    if (url.pathname === "/chat" && request.method === "POST") {
      let body;
      try { body = await request.json(); } catch { return reply({ error: "Invalid JSON" }, 400); }
      const userId = String(body.userId ?? "");
      const gameId = clean(body.gameId, 32);
      const username = clean(body.username, 20);
      const prefix = clean(body.prefix || "Player", 16);
      const color = String(body.color || "#B9CDFF");
      const message = clean(body.message, 240);
      if (userId !== "7162643277") return reply({ error: "Only the DiamondBoatHub owner can send messages" }, 403);
      if (!validId(userId) || !gameId || !username || !message || !validColor(color)) {
        return reply({ error: "Invalid userId, gameId, username, message, or color" }, 400);
      }
      const rateKey = "chat-rate:" + gameId + ":" + userId;
      if (await env.PREFIXES.get(rateKey)) return reply({ error: "Please wait before sending another message" }, 429);
      await env.PREFIXES.put(rateKey, "1", { expirationTtl: 2 });
      const createdAt = Date.now();
      const messageId = (globalThis.crypto && typeof globalThis.crypto.randomUUID === "function") ? globalThis.crypto.randomUUID() : (String(createdAt) + "-" + Math.random().toString(36).slice(2));
      const record = { id: messageId, userId, username, prefix, color: color.toUpperCase(), message, createdAt };
      await env.PREFIXES.put("chat:" + gameId + ":" + String(createdAt).padStart(13, "0") + ":" + record.id, JSON.stringify(record), { expirationTtl: 86400 });
      return reply({ ok: true, message: record });
    }

    // Short-lived server presence. Each client refreshes its own record every 20 seconds.
    if (url.pathname === "/presence" && request.method === "POST") {
      let body;
      try { body = await request.json(); } catch { return reply({ error: "Invalid JSON" }, 400); }
      const userId = String(body.userId ?? "");
      const gameId = clean(body.gameId, 32);
      const jobId = clean(body.jobId, 64);
      const username = clean(body.username, 20);
      const prefix = clean(body.prefix || "Player", 16);
      const color = String(body.color || "#B9CDFF");
      if (!validId(userId) || !gameId || !jobId || !/^[a-zA-Z0-9-]+$/.test(jobId) || !username || !validColor(color)) {
        return reply({ error: "Invalid presence data" }, 400);
      }
      const record = { userId, gameId, jobId, username, prefix, color: color.toUpperCase(), updatedAt: Date.now() };
      await env.PREFIXES.put("presence:" + gameId + ":" + jobId + ":" + userId, JSON.stringify(record), { expirationTtl: 90 });
      return reply({ ok: true });
    }

    if (url.pathname === "/servers" && request.method === "GET") {
      const gameId = clean(url.searchParams.get("gameId"), 32);
      if (!gameId || !validId(gameId)) return reply({ error: "Valid gameId is required" }, 400);
      const grouped = new Map();
      // First include DiamondBoatHub users currently reporting their server presence.
      const listed = await env.PREFIXES.list({ prefix: "presence:" + gameId + ":", limit: 1000 });
      for (const key of listed.keys) {
        const raw = await env.PREFIXES.get(key.name);
        if (!raw) continue;
        try {
          const player = JSON.parse(raw);
          if (!player.jobId || Date.now() - Number(player.updatedAt || 0) > 90000) continue;
          if (!grouped.has(player.jobId)) grouped.set(player.jobId, {
            jobId: player.jobId, players: [], playing: 0, maxPlayers: 0, hubUsers: true
          });
          grouped.get(player.jobId).players.push({
            userId: player.userId, username: player.username, prefix: player.prefix, color: player.color
          });
        } catch {}
      }
      // Also list public Roblox servers, even when no hub users have reported presence there.
      let publicListAvailable = false;
      try {
        const api = await fetch("https://games.roblox.com/v1/games/" + gameId + "/servers/Public?sortOrder=Asc&limit=100");
        if (api.ok) {
          const data = await api.json();
          if (Array.isArray(data.data)) {
            publicListAvailable = true;
            for (const server of data.data) {
              if (!server || typeof server.id !== "string" || !/^[a-zA-Z0-9-]+$/.test(server.id)) continue;
              const existing = grouped.get(server.id);
              if (existing) {
                existing.playing = Number(server.playing || existing.players.length);
                existing.maxPlayers = Number(server.maxPlayers || 0);
              } else {
                grouped.set(server.id, {
                  jobId: server.id, players: [], playing: Number(server.playing || 0),
                  maxPlayers: Number(server.maxPlayers || 0), hubUsers: false
                });
              }
            }
          }
        }
      } catch (error) {
        // Presence-only results remain usable if Roblox's public server API is unavailable.
      }
      return reply({ ok: true, servers: Array.from(grouped.values()), publicListAvailable });
    }

    if (url.pathname === "/prefix" && request.method === "POST") {
      let body;
      try { body = await request.json(); } catch { return reply({ error: "Invalid JSON" }, 400); }
      const userId = String(body.userId ?? "");
      const gameId = clean(body.gameId, 32);
      const prefix = clean(body.prefix, 16);
      const color = String(body.color ?? "#B9CDFF");
      const username = clean(body.username, 20);
      if (!validId(userId) || !gameId || !prefix || !validColor(color)) return reply({ error: "Invalid userId, gameId, prefix, or color" }, 400);
      const record = { userId, gameId, prefix, color: color.toUpperCase(), username, updatedAt: Date.now() };
      await env.PREFIXES.put(gameId + ":" + userId, JSON.stringify(record), { expirationTtl: 86400 });
      return reply({ ok: true, record });
    }

    if (url.pathname === "/players" && request.method === "GET") {
      const gameId = clean(url.searchParams.get("gameId"), 32);
      if (!gameId) return reply({ error: "gameId is required" }, 400);
      const listed = await env.PREFIXES.list({ prefix: gameId + ":", limit: 100 });
      const records = [];
      for (const key of listed.keys) {
        const raw = await env.PREFIXES.get(key.name);
        if (!raw) continue;
        try { records.push(JSON.parse(raw)); } catch {}
      }
      return reply({ ok: true, players: records });
    }

    if (url.pathname === "/prefix" && request.method === "DELETE") {
      let body;
      try { body = await request.json(); } catch { return reply({ error: "Invalid JSON" }, 400); }
      const userId = String(body.userId ?? "");
      const gameId = clean(body.gameId, 32);
      if (!validId(userId) || !gameId) return reply({ error: "Invalid userId or gameId" }, 400);
      await env.PREFIXES.delete(gameId + ":" + userId);
      return reply({ ok: true });
    }
    return reply({ error: "Not found" }, 404);
    } catch (error) {
      const detail = String(error && (error.stack || error.message) || error).slice(0, 1800);
      return reply({ error: "Worker exception", detail }, 500);
    }
  }
};

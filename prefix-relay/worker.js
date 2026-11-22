// DiamondBoatHub shared-prefix relay (Cloudflare Worker + KV)
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
    if (request.method === "OPTIONS") return new Response(null, { headers: cors });
    if (!env.PREFIXES) return reply({ error: "KV binding PREFIXES is missing" }, 500);
    const url = new URL(request.url);
    if (url.pathname === "/health" && request.method === "GET") return reply({ ok: true, service: "DiamondBoatHub Prefix Relay", version: 1 });

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
  }
};

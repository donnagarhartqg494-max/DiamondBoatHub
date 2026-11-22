# DiamondBoatHub shared prefixes

This is an optional Cloudflare Worker relay. It stores short prefix/color records in Cloudflare KV and lets other DiamondBoatHub clients in the same Roblox place read them.

## Deploy
1. Create a Cloudflare Worker named `diamondboathub-prefixes`.
2. Create a Workers KV namespace, e.g. `DIAMOND_PREFIXES`.
3. In Worker **Settings → Bindings**, add a KV namespace binding named **PREFIXES** pointing to that namespace.
4. Paste `worker.js` into the Worker editor and deploy.
5. Open `https://YOUR-WORKER.workers.dev/health`; it should return `{"ok":true,...}`.

## API
- `POST /prefix`: JSON `{"userId":"123","gameId":"PLACE_ID","username":"Player","prefix":"VIP","color":"#B9CDFF"}`
- `GET /players?gameId=PLACE_ID`
- `DELETE /prefix`: JSON `{"userId":"123","gameId":"PLACE_ID"}`

Records expire after 24 hours.

## Security and limitations
This is a public prototype relay, not an authenticated Roblox service. An executor client cannot securely prove that a submitted Roblox UserId belongs to the sender, so users can spoof or overwrite displayed records. Do not use it for permissions, moderation, purchases, or trust decisions. Prefix filtering in the client is not Roblox TextService filtering. For a production implementation, use a Roblox-owned server Script with RemoteEvents and TextService; that requires access to the game's place source. Do not put private API keys in the client script.

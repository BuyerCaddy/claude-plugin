![BuyerCaddy](assets/buyercaddy-logo.png)

# BuyerCaddy for Claude — 0.5.0

Research companies, software adoption, vendors, customers and cohorts, and check account credits and usage using BuyerCaddy tools in Claude chat. This standalone plugin includes research and credits skills with a remote MCP connector. It does not require a local server, Node.js, an MCPB extension or a shared API key.

## Install and connect

1. In Claude, open Customize > Plugins > Add > Upload plugin (some clients show Settings > Plugins).
2. Upload `buyercaddy-claude-oauth-0.5.0.zip` as supplied; do not upload a marketplace archive.
3. Open the installed plugin's Connectors tab and add/connect BuyerCaddy. On Team and Enterprise, an Owner may need to add the connector for the organization first.
4. On the BuyerCaddy page headed **Connect to BuyerCaddy MCP**, enter your own BuyerCaddy API key and select Connect.
5. Return to Claude and try: **Find the Salesforce vendor in BuyerCaddy.**

Each customer signs in with their own key. Never paste it into the conversation. This package contains no key, client secret, environment-variable credential template or executable bridge. If an older BuyerCaddy connector is also enabled, select the new connector below to avoid testing the old direct endpoint.

## MCP configuration

```json
{
  "mcpServers": {
    "buyercaddy": {
      "type": "http",
      "url": "https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp"
    }
  }
}
```

Claude discovers the gateway's OAuth endpoints from its protected-resource and authorization-server metadata. The gateway uses public dynamic client registration and authorization code with PKCE S256. Customers do not manually enter OAuth client credentials. After sign-in, Claude uses a gateway access token; the gateway forwards the customer's original API key to the existing BuyerCaddy MCP service in `X-Api-Key`.

- Protected resource metadata: https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/.well-known/oauth-protected-resource/mcp
- Authorization server metadata: https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/.well-known/oauth-authorization-server
- Enabled hosted Claude callback: `https://claude.ai/api/mcp/auth_callback`

This release targets hosted Claude chat, including the hosted connector used from Claude Desktop. It is not a local Claude Code OAuth release: loopback callbacks are not enabled on this gateway.

## Contents and verification

The ZIP has `.claude-plugin/plugin.json` at its root, with `.mcp.json`, `skills/` and `assets/` beside it. It does not contain a marketplace wrapper. The research references include a dated upstream schema snapshot; the current connected tool schema takes precedence.

The official logo and square brand asset are included. The common plugin manifest has no documented icon field, so this release does not invent one or promise a custom catalogue thumbnail. The sign-in form uses the BuyerCaddy logo.

Package validation does not prove installation or successful sign-in in your Claude account. Confirm the connector is connected and a real tool call succeeds after installation. This ZIP has not been submitted to the public directory.

Official plugin structure and installation reference: https://claude.com/docs/plugins/build

## New in 0.5.0

- Added a dedicated credits skill for `GetCreditsBalance` and `GetCreditsReport`.
- Refreshed the bundled schema snapshot to the 20 tools published on 2026-10-01, including server documentation for credits.
- Preserved the existing OAuth endpoint and key-free MCP configuration.

Upload this ZIP to update the installed BuyerCaddy plugin. Confirm version 0.5.0 and that BuyerCaddy is connected on its Connectors tab. If an existing chat has a stale tool inventory, refresh/reconnect the connector and open a new chat. The connector obtains tool definitions from the live server; the ZIP provides usage instructions rather than registering a fixed list of tools.

Try: "Сколько у меня осталось кредитов?" or "Покажи расход кредитов за сентябрь 2026 года по API-методам". Reports update hourly and do not measure immediate charges. The default is the connected account; delegated balance checks require authorized identity, and the report has no delegation parameter.

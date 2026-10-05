# Connection and tool failures

- Missing tools: open this plugin's Connectors tab in Claude and add/connect BuyerCaddy. On Team or Enterprise, an organization Owner may need to add the connector first. Installing the plugin makes the skill available; it does not complete sign-in. Use only tools advertised in the current connection.
- Sign-in: use the browser page headed "Connect to BuyerCaddy MCP" and enter your own BuyerCaddy API key there. Never paste a key into the conversation. No OAuth Client ID or Client Secret needs to be copied by the customer.
- Registration failure: verify that the connector uses the gateway URL in the bundled .mcp.json. A previous connector pointing directly to mcp.salescaddy.ai does not use this OAuth gateway. Do not switch the new connector to that legacy URL.
- Unauthorized, expired or revoked credential: stop data requests and reconnect through the connector. Do not use another account or an anonymous/shared fallback.
- Invalid arguments: read the live schema, fix types/enums/required fields and retry once with corrected arguments.
- 429/temporary outage: honor server retry guidance; retain completed results. A model-backed call may already have incurred usage, so ask before repeating work with uncertain outcome.
- Tool isError, success:false, malformed response, or missing rows array: treat as an error, not a zero count. Preserve the tool name and a safe support/request ID if supplied. Omit backend stack traces, SQL and secrets.
- Changing or repeated pages: stop as incomplete; use a narrower deterministic query or continue after service recovery.

The gateway handles OAuth and forwards the user's key to BuyerCaddy MCP. The existing API decides key validity, access and quotas. This plugin cannot repair a server-side error. This release targets hosted Claude chat; local Claude Code callback URLs are not enabled on the gateway.

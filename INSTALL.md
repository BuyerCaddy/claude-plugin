# BuyerCaddy 0.5.0 for Claude

1. In Claude, open Customize / Settings > Plugins > Add > Upload plugin.
2. Upload `buyercaddy-claude-oauth-0.5.0.zip`.
3. Open the installed plugin's Connectors tab and connect BuyerCaddy.
4. In the **Connect to BuyerCaddy MCP** form, enter your own API key and select **Connect**.
5. Return to the chat and ask: "Find the Salesforce vendor using BuyerCaddy."

On Team / Enterprise, an organization owner may need to add the connector first. Each user connects with their own key. Enter your key only in the connection form, never in the chat or ZIP. You do not need to enter an OAuth Client ID or Client Secret.

Connector URL: https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp

An older connection directly to mcp.salescaddy.ai does not use this OAuth gateway. Select the new connection when checking the plugin. This archive is intended for Claude chat with a remote connector; local Claude Code authorization is not enabled in this gateway version.

## What's new in 0.5.0

Added instructions for checking the current credit balance (`GetCreditsBalance`) and credit usage (`GetCreditsReport`). The tool reference now covers 20 tools. The OAuth URL and individual authentication remain unchanged.

After uploading, confirm version 0.5.0 and that BuyerCaddy is connected. If an existing chat does not see the new tools, refresh or reconnect the connector and start a new chat.

Try these prompts:

- "How many credits do I have left?"
- "Show my credit usage for September 2026."
- "Which API methods have used my credits over all time?"

The report updates hourly. Values represent credits, not a monetary balance. An error or a missing field must not be treated as zero.

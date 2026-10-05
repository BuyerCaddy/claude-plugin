# Install BuyerCaddy for Claude

This guide covers Claude chat on the web and in Claude Desktop with the hosted OAuth connector. The current version is defined in the [plugin manifest](.claude-plugin/plugin.json).

## Before you start

- Confirm your Claude account has access to Plugins and remote connectors. On Team or Enterprise, an organization Owner may need to add the connector first.
- Have your own BuyerCaddy API key ready. If needed, [create a BuyerCaddy account](https://buyercaddy.com/sign-up/?plan=claude).
- Build the installation ZIP using the [README build instructions](README.md#1-build-the-installation-zip). No local server or Node.js is needed.

## Install and authorize

1. In Claude, open **Customize > Plugins > Add > Upload plugin**.
2. Upload `dist/buyercaddy-claude-plugin.zip`.
3. Open the installed **BuyerCaddy** plugin's **Connectors** tab and add or connect BuyerCaddy.
4. In the **Connect to BuyerCaddy MCP** form, enter your own API key and select **Connect**.
5. Return to Claude and confirm that BuyerCaddy is connected.
6. Start a new chat and ask: **Find the Salesforce vendor using BuyerCaddy.** Confirm that Claude calls a BuyerCaddy tool and returns its result.

Enter the key only in the connection form, never in the chat or plugin files. You do not need an OAuth Client ID or Client Secret. The upload and connection steps are documented by [Anthropic](https://claude.com/docs/plugins/build).

The connector URL is:

```text
https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp
```

If an older connection points directly to mcp.salescaddy.ai, select the new OAuth connection. This gateway release does not support local Claude Code OAuth callbacks.

## Start using the plugin

Ask Claude in natural language:

- "Find 10 companies recorded as using Salesforce products in BuyerCaddy."
- "How many BuyerCaddy credits do I have left?"
- "Show my BuyerCaddy credit usage for September 2026 by API method."

Usage reports update hourly. Values represent credits, not money. See the [README](README.md#3-use-buyercaddy-in-a-chat) for more examples.

## Update an existing installation

1. From a clean local checkout, run `git pull --ff-only` and then `python scripts/package.py` (or `python3 scripts/package.py`).
2. Upload the newly generated ZIP through the same Plugins interface and follow any update prompt.
3. Check the installed version against the plugin manifest and confirm BuyerCaddy is connected.
4. If the chat still shows an old tool list, refresh or reconnect the connector and start a new chat.

The ZIP filename stays the same across releases; check the manifest for its version. GitHub updates are not automatically applied to an uploaded plugin.

For missing tools, sign-in errors or ZIP problems, see [Troubleshooting](README.md#troubleshooting).

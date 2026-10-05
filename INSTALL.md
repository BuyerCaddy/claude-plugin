# Install BuyerCaddy for Claude

This guide covers Claude Chat (web and Desktop) and Claude Code using the same hosted OAuth connector. The current version is defined in the [plugin manifest](.claude-plugin/plugin.json).

## Before you start

- For Claude Chat, confirm your account has access to Plugins and remote connectors. On Team or Enterprise, an organization Owner may need to add the connector first. For Claude Code, install the CLI and sign in first.
- Have your own BuyerCaddy API key ready. If needed, [create a BuyerCaddy account](https://buyercaddy.com/sign-up/?plan=claude).
- [Download the ready-to-install ZIP](https://github.com/BuyerCaddy/claude-plugin/releases/latest/download/buyercaddy-claude-plugin.zip). No build tools are required. Alternatively, [build from source with Python or PowerShell](README.md#build-from-source-optional).

## Install in Claude Chat

1. In Claude, open **Customize > Plugins > Add > Upload plugin**.
2. Upload the downloaded `buyercaddy-claude-plugin.zip`, or the copy in `dist/` if you built it yourself. Use the release asset, not GitHub's automatic **Source code** archive.
3. Open the installed **BuyerCaddy** plugin's **Connectors** tab and add or connect BuyerCaddy.
4. In the **Connect to BuyerCaddy MCP** form, enter your own API key and select **Connect**.
5. Return to Claude and confirm that BuyerCaddy is connected.
6. Start a new chat and ask: **Find the Salesforce vendor using BuyerCaddy.** Confirm that Claude calls a BuyerCaddy tool and returns its result.

Enter the key only in the connection form, never in the chat or plugin files. You do not need an OAuth Client ID or Client Secret. The upload and connection steps are documented by [Anthropic](https://claude.com/docs/plugins/build).

The connector URL is:

```text
https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp
```

If an older connection points directly to mcp.salescaddy.ai, select the new OAuth connection.

## Install in Claude Code

1. Extract the release ZIP into a folder, or clone the repository.
2. From your working project, run `claude --plugin-dir "/path/to/claude-plugin"`, replacing the path with that folder. Keep using this flag for subsequent sessions.
3. Run `/mcp`, select the plugin's BuyerCaddy server, and authenticate.
4. Enter your own API key on the BuyerCaddy browser page. The browser returns to a temporary local callback opened by Claude Code.
5. Confirm the server is connected, then ask: **Find the Salesforce vendor using BuyerCaddy.**

No local BuyerCaddy server or embedded key is needed. Use the plugin's connection rather than creating a second MCP entry. Launch from your working project, not the plugin repository, so its `.mcp.json` is not also loaded as project configuration. The research and credits skills can be invoked with `/buyercaddy:research` and `/buyercaddy:credits`.

## Start using the plugin

Ask Claude in natural language:

- "Find 10 companies recorded as using Salesforce products in BuyerCaddy."
- "How many BuyerCaddy credits do I have left?"
- "Show my BuyerCaddy credit usage for September 2026 by API method."

Usage reports update hourly. Values represent credits, not money. See the [README](README.md#3-use-buyercaddy-in-a-chat) for more examples.

## Update an existing installation

1. Download the ZIP from the [latest release](https://github.com/BuyerCaddy/claude-plugin/releases/latest). If building from source instead, run `git pull --ff-only` from a clean checkout and use either builder in the README.
2. For Claude Chat, upload the new ZIP through the same Plugins interface and follow any update prompt. For Claude Code, extract the new ZIP into your plugin folder (or update its checkout), then restart with `--plugin-dir` pointing to that folder.
3. Check the installed version against the plugin manifest and confirm BuyerCaddy is connected.
4. If the tool list is stale, reconnect on the Connectors tab in Claude Chat or through `/mcp` in Claude Code, then start a new session.

The ZIP filename stays the same across releases; check the manifest for its version. GitHub updates are not automatically applied to an uploaded plugin.

For missing tools, sign-in errors or ZIP problems, see [Troubleshooting](README.md#troubleshooting).

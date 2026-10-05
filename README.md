![BuyerCaddy](assets/buyercaddy-logo.png)

# BuyerCaddy for Claude

Research companies, software products, vendors, customers and technology adoption in Claude. Check your BuyerCaddy credit balance and usage in the same conversation.

Version **0.5.0** includes two skills, **research** and **credits**, and a remote MCP connector. Each user connects through OAuth. The plugin contains no API key or client secret.

## Requirements

- A Claude account with access to **Customize > Plugins** and remote connectors. Organization policies may require an Owner to enable the connector.
- Your own BuyerCaddy API key, entered on the BuyerCaddy connection page. If needed, [create a BuyerCaddy account](https://buyercaddy.com/sign-up/?plan=claude).
- To build the installation ZIP: Git and PowerShell 7 (or Windows PowerShell 5.1).

This release is for Claude chat on the web and in Claude Desktop. The current gateway does not support local Claude Code OAuth callbacks. No local server or Node.js installation is needed.

## 1. Build the installation ZIP

Run these commands in PowerShell:

```powershell
git clone https://github.com/BuyerCaddy/claude-plugin.git
Set-Location claude-plugin
./scripts/package.ps1
```

If you already cloned the repository, run `./scripts/package.ps1` from its root.

Output for the current version: `dist/buyercaddy-claude-oauth-0.5.0.zip`.

The script reads the manifest version, checks JSON and the OAuth configuration, and packages the plugin files, including hidden files and the license. It prints the archive path and SHA-256 hash. Nothing needs compiling and no credentials are required.

Upload this generated ZIP to Claude. Its root contains `.claude-plugin/plugin.json` and `.mcp.json`, without Git metadata or build scripts.

## 2. Install and connect

1. In Claude, open **Customize > Plugins > Add > Upload plugin**.
2. Select `dist/buyercaddy-claude-oauth-0.5.0.zip`.
3. Open the installed **BuyerCaddy** plugin's **Connectors** tab and add or connect BuyerCaddy.
4. On the **Connect to BuyerCaddy MCP** page, enter your own BuyerCaddy API key and select **Connect**.
5. Return to Claude, confirm the connector is connected, and start a new chat.

On Team and Enterprise, an organization Owner may need to add the connector before members can connect their accounts. Installing the plugin and connecting the account are separate steps.

Enter your API key only on the connection page. Do not paste it into a chat or edit it into the plugin files. You do not need an OAuth Client ID or Client Secret.

See [INSTALL.md](INSTALL.md) for installation and update steps. The upload and connector flow follows [Anthropic's plugin documentation](https://claude.com/docs/plugins/build).

## 3. Use BuyerCaddy in a chat

Ask in natural language and name BuyerCaddy when you want Claude to use its data. No slash command is required.

| Task | Example prompt |
| --- | --- |
| First connection check | Find the Salesforce vendor using BuyerCaddy. |
| Company research | Use BuyerCaddy to summarize microsoft.com and identify its recorded software products. |
| Customer discovery | Find 10 companies recorded as using Salesforce products in BuyerCaddy. Show their names and domains. |
| Technology lookup | Use BuyerCaddy to check whether microsoft.com is recorded as using Slack. |
| Remaining credits | How many BuyerCaddy credits do I have left? |
| Usage by API method | Show my BuyerCaddy credit usage for September 2026, grouped by API method. |

For the first connection check, confirm Claude actually calls a BuyerCaddy tool and returns its result. A general answer about Salesforce does not verify the connection. These examples are requests, not guarantees that particular data will be returned.

Credit usage reports update hourly, so recent activity may be missing. Use the balance tool for current remaining credits. Credits are not money, and a failed request is not a zero balance.

## Troubleshooting

| Symptom | What to do |
| --- | --- |
| Plugins or connector setup is unavailable | Check your Claude account's available features and organization policy; ask your organization Owner if applicable. |
| ZIP upload reports a missing manifest | Use the ZIP produced by the packaging script; it includes the hidden manifest in the correct location. |
| The plugin is installed but tools are missing | Open its Connectors tab, connect BuyerCaddy, then start a new chat. |
| Sign-in fails or the connector is unauthorized | Reconnect through the BuyerCaddy form with your own valid key. |
| An old BuyerCaddy connection is still selected | Use the OAuth gateway URL below. The older direct mcp.salescaddy.ai connection does not use this sign-in flow. |
| Tools remain missing after an update | Refresh or reconnect BuyerCaddy and start a new chat. |
| Credit usage does not include recent activity | Allow for the report's hourly refresh. |

See the [troubleshooting reference](skills/research/references/troubleshooting.md) for tool errors and pagination limits.

## Connection and repository layout

[.mcp.json](.mcp.json) points to the hosted OAuth connector:

```text
https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp
```

Claude discovers the gateway's OAuth configuration and opens its sign-in page. After connection, Claude uses an access token; the gateway forwards the user's key to BuyerCaddy. No environment variables need configuring in this plugin.

| Path | Purpose |
| --- | --- |
| .claude-plugin/plugin.json | Plugin identity and version |
| .mcp.json | Remote OAuth connector |
| skills/research/ | Research instructions and tool references |
| skills/credits/ | Credit balance and usage instructions |
| assets/ | BuyerCaddy brand images |
| INSTALL.md | Installation and update guide |
| scripts/package.ps1 | Builds and checks the installation ZIP |
| dist/ | Generated ZIP; excluded from Git |

The bundled schema is a snapshot of 20 tools from October 1, 2026. The connected server supplies the current tool definitions; the plugin provides instructions for using them.

## Maintainer checks

After editing, run `./scripts/package.ps1`. If Claude Code is installed, optionally validate the manifest from the repository root:

```powershell
claude plugin validate .
```

Manifest and archive checks do not verify account sign-in. Upload the ZIP to the target Claude account, connect BuyerCaddy and run the first connection check above to verify the complete flow.

To prepare a new plugin version, update the manifest and version references in this README and INSTALL.md, rebuild, and follow the [update steps](INSTALL.md#update-an-existing-installation). Pushing to GitHub alone does not update an installed plugin. This repository distributes a standalone plugin and has no marketplace catalog.

## License

See [LICENSE](LICENSE).

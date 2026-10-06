![BuyerCaddy](assets/buyercaddy-logo.png)

# BuyerCaddy for Claude

Research companies, software products, vendors, customers and technology adoption in Claude. Check your BuyerCaddy credit balance and usage in the same conversation.

The plugin includes two skills, **research** and **credits**, and a remote MCP connector. Each user connects through OAuth. The plugin contains no API key or client secret. The current version is defined in the [plugin manifest](.claude-plugin/plugin.json).

## Requirements

- For Claude Chat: an account with access to **Customize > Plugins** and remote connectors. Organization policies may require an Owner to enable the connector. For Claude Code: an installed and signed-in Claude Code CLI.
- Your own BuyerCaddy API key, entered on the BuyerCaddy connection page. If needed, [create a BuyerCaddy account](https://buyercaddy.com/sign-up/?plan=claude).
- Only if building from source: Git and either Python 3.9+ or PowerShell (Windows PowerShell 5.1 or PowerShell 7+). Choose either builder; you do not need both.

The same plugin supports Claude Chat on the web and in Claude Desktop, and Claude Code. Both use the hosted BuyerCaddy MCP service and browser-based OAuth. Claude Code briefly listens on a local callback port to finish sign-in; no local BuyerCaddy server is needed.

## 1. Get the installation ZIP

### Download the ready-to-install plugin

[Download buyercaddy-claude-plugin.zip](https://github.com/BuyerCaddy/claude-plugin/releases/latest/download/buyercaddy-claude-plugin.zip)

No Git, Python or PowerShell is required. Download the ZIP and continue to [Install and connect](#2-install-and-connect). Previous versions and release notes are available in [GitHub Releases](https://github.com/BuyerCaddy/claude-plugin/releases).

Choose the attached `buyercaddy-claude-plugin.zip` asset, not GitHub's automatically generated **Source code** archives.

### Build from source (optional)

Clone the repository in your terminal:

```sh
git clone https://github.com/BuyerCaddy/claude-plugin.git
cd claude-plugin
```

If you already cloned the repository, open a terminal in its root. Then choose **one** of these independent builders:

**Python — Windows, macOS or Linux:**

```sh
python scripts/package.py
```

If your system uses `python3` instead of `python`, run `python3 scripts/package.py`. On Windows, `py -3 scripts/package.py` also works when the Python launcher is installed. No third-party Python packages are required.

**PowerShell — Windows PowerShell 5.1 or PowerShell 7+:**

```powershell
./scripts/package.ps1
```

Run this command in a PowerShell terminal. This builder uses .NET libraries included with PowerShell and does not require Python.

Output: `dist/buyercaddy-claude-plugin.zip`. The filename stays the same across releases; the plugin version comes from the manifest. Running the script again replaces this generated archive.

Both builders read the manifest version, check JSON and the OAuth configuration, and package the same plugin files, including hidden files and the license. Each prints the archive path and SHA-256 hash. Nothing needs compiling and no credentials are required.

Upload this generated ZIP to Claude. Its root contains `.claude-plugin/plugin.json` and `.mcp.json`, without Git metadata or build scripts.

## 2. Install and connect

### Claude Chat (web and Desktop)

1. In Claude, open **Customize > Plugins > Add > Upload plugin**.
2. Select the downloaded `buyercaddy-claude-plugin.zip`, or the copy in `dist/` if you built it yourself.
3. Open the installed **BuyerCaddy** plugin's **Connectors** tab and add or connect BuyerCaddy.
4. On the **Connect to BuyerCaddy MCP** page, enter your own BuyerCaddy API key and select **Connect**.
5. Return to Claude, confirm the connector is connected, and start a new chat.

On Team and Enterprise, an organization Owner may need to add the connector before members can connect their accounts. Installing the plugin and connecting the account are separate steps.

Enter your API key only on the connection page. Do not paste it into a chat or edit it into the plugin files. You do not need an OAuth Client ID or Client Secret.

See [INSTALL.md](INSTALL.md) for installation and update steps. The upload and connector flow follows [Anthropic's plugin documentation](https://claude.com/docs/plugins/build).

### Claude Code

Extract the release ZIP into a folder, or clone this repository. From your working project, start Claude Code with the path to that plugin folder:

```sh
claude --plugin-dir "/path/to/claude-plugin"
```

Replace the path with your actual extracted or cloned folder. It must contain `.claude-plugin/plugin.json`. This loads the plugin for that session; use the flag again in future sessions.

1. Run `/mcp` inside Claude Code, select the BuyerCaddy server supplied by the plugin, and choose to authenticate.
2. Complete sign-in in your browser using your own BuyerCaddy API key.
3. Let the browser return to Claude Code's local callback, then confirm the server is connected in `/mcp`.
4. Ask: **Find the Salesforce vendor using BuyerCaddy.**

The skills are also available as `/buyercaddy:research` and `/buyercaddy:credits`. Use the plugin's MCP connection rather than adding a duplicate with `claude mcp add`. Run Claude Code from your working project rather than the plugin repository to avoid loading its `.mcp.json` twice. See [Claude Code's MCP documentation](https://code.claude.com/docs/en/mcp#authenticate-with-remote-mcp-servers) for the browser sign-in flow.

## 3. Use BuyerCaddy in a chat

Ask in natural language and name BuyerCaddy when you want Claude to use its data. No slash command is required.

| Task | Example prompt |
| --- | --- |
| First connection check | Show me a list of products by Snowflake. |
| Company research | Use BuyerCaddy to summarize microsoft.com and identify its recorded software products. |
| Customer discovery | Find customers of DStabricks. |
| Technology lookup | Use BuyerCaddy to check whether microsoft.com is recorded as using Slack. |
| Remaining credits | How many BuyerCaddy credits do I have left? |
| Usage by API method | Show my BuyerCaddy credit usage for September 2026, grouped by API method. |

For the first connection check, confirm Claude actually calls a BuyerCaddy tool and returns its result. A general answer about Salesforce does not verify the connection. These examples are requests, not guarantees that particular data will be returned.

Credit usage reports update hourly, so recent activity may be missing. Use the balance tool for current remaining credits. Credits are not money, and a failed request is not a zero balance.

## Troubleshooting

| Symptom | What to do |
| --- | --- |
| Python is not found or opens the Microsoft Store | Download the ready-made ZIP, use the PowerShell builder, or install Python 3.9+ and reopen the terminal. |
| Plugins or connector setup is unavailable | Check your Claude account's available features and organization policy; ask your organization Owner if applicable. |
| ZIP upload reports a missing manifest | Use the release asset or a ZIP produced by either builder; both include the hidden manifest in the correct location. |
| The plugin is installed but tools are missing | In Claude Chat, connect BuyerCaddy on its Connectors tab and start a new chat. In Claude Code, authenticate the plugin's server through `/mcp`. |
| Claude Code cannot finish the browser redirect | Keep the originating Claude Code session open. The browser must reach the callback on that computer. For SSH or remote sessions, follow Claude Code's callback-paste instructions if offered. |
| Sign-in fails or the connector is unauthorized | Reconnect through the BuyerCaddy form with your own valid key. |
| An old BuyerCaddy connection is still selected | Use the OAuth gateway URL below. The older direct mcp.salescaddy.ai connection does not use this sign-in flow. |
| Tools remain missing after an update | Refresh or reconnect BuyerCaddy and start a new chat; restart Claude Code with the updated plugin folder. |
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
| scripts/package.py | Python builder |
| scripts/package.ps1 | Independent PowerShell builder |
| dist/ | Generated ZIP; excluded from Git |

The bundled schema is a snapshot of 20 tools from October 1, 2026. The connected server supplies the current tool definitions; the plugin provides instructions for using them.

## Maintainer checks

After editing, run either `python scripts/package.py` (or `python3 scripts/package.py`) or `./scripts/package.ps1` in PowerShell. If Claude Code is installed, optionally validate the manifest from the repository root:

```sh
claude plugin validate .
```

Manifest and archive checks do not verify account sign-in. Upload the ZIP to the target Claude account, connect BuyerCaddy and run the first connection check above to verify the complete flow.

To publish a new version, update `.claude-plugin/plugin.json`, commit and push the changes, build the ZIP from that commit, and create a GitHub Release with a matching version tag. Attach `dist/buyercaddy-claude-plugin.zip` and mark the release as latest so the download link above serves it. Users then follow the [update steps](INSTALL.md#update-an-existing-installation). Pushing to GitHub alone does not update the release asset or an installed plugin. This repository distributes a standalone plugin and has no marketplace catalog.

## License

See [LICENSE](LICENSE).

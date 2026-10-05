---
name: credits
description: Check BuyerCaddy account credit balance, remaining credits, or credit usage by date and API endpoint. Use when the user asks how many credits remain, where credits were spent, or requests a usage report or a balance check before research.
argument-hint: "<balance or credit usage period>"
---

# BuyerCaddy credits

Use the connected BuyerCaddy MCP tools. Identify their exact names from the current tool descriptions; hosts may add a prefix. Read [credits-guide.md](references/credits-guide.md) for response fields, date rules, delegated access and error handling before making a credits call. If available, `buyercaddy://docs/credits` and the current tool schemas supersede this bundled documentation snapshot.

## Choose and execute the requested read

| User request | Tool and arguments |
|---|---|
| Current or remaining credits for the connected account | `GetCreditsBalance` with `{}` |
| Usage for a specified period or breakdown by API endpoint | `GetCreditsReport` with `from` and/or `to` |
| Explicit all-time usage | `GetCreditsReport` with `{}` |
| Both remaining credits and usage | Call both tools for the requested account and period |

1. Preserve the user's account and date scope. Use the connected account by default. For an unspecified usage period, ask which period they want; use `{}` immediately when they explicitly request the whole usage period. Convert relative dates using the user's current date and timezone when available and state the concrete range. Ask only when the intended range remains ambiguous.
2. Send real calendar dates in `YYYY-MM-DD` format. Include only provided or resolved boundaries; a single boundary is supported. Check `from <= to` when both are present. The API does not define boundary inclusivity or its reporting timezone; leave these unspecified.
3. Read the tool result as an object, whether returned as text JSON or structured content. Inspect transport, protocol and `isError`/`success:false` failures before interpreting account values. Parse int64 values losslessly when using code; preserve exact digits from raw JSON if the client may round large integers.
4. Return the requested balance or usage with its scope. For balance, label `value` as credits and identify it as the current value returned by `GetCreditsBalance`. For a report, label `count` as credits used, preserve the requested date range, and show returned `details` grouped by their returned `path` if a breakdown is requested. Keep `rowCount` labeled as `rowCount`: its unit is unspecified. Missing fields are unavailable, while an explicit numeric zero is zero.
5. State that usage reports update once an hour and recent activity may be absent. Use `GetCreditsBalance` for current remaining credits; a report is not an immediate before/after charge measurement. Finish after the requested reads succeed or report the exact limitation.

## Account and connection boundaries

- Use `onBehalfOfUser` only with `GetCreditsBalance`, only for an explicitly requested identity whose delegation is established as authorized. An email in a prompt alone does not establish authorization. Omit it for the connected account. `GetCreditsReport` has no delegation parameter; explain this limit if another user's usage is requested, rather than silently substituting the connected account's report.
- Both tools are reads. They cannot top up, transfer, refund, purchase or set a spending limit. A balance alone does not establish the cost of a proposed search. Request a price or estimate from a verified source if needed.
- Invoke credit checks when the user requests them or when needed for an explicit credit-budget task. Ordinary company research does not require an extra balance call. Avoid polling the hourly report to wait for fresh charges.
- If tools are missing, open BuyerCaddy's Connectors tab in Claude and reconnect or refresh the available tools. If authorization fails, direct the user to reconnect through the plugin's OAuth form. API keys and OAuth tokens belong only in the connection, never in the chat, tool arguments, URLs or reports. Do not fall back to a shared identity.
- A failed call is an unavailable result, not a zero balance or empty report. For 400, correct the supplied arguments; for 401, reconnect; for 403, report insufficient permission; for 429 or temporary failures, respect retry guidance. Keep account identifiers, credentials and backend diagnostics out of the answer unless an identifier is necessary for the user's requested scope.

## Examples

- "How many credits do I have left?" → `GetCreditsBalance({})`.
- "Show my credit usage for September 2026" → `GetCreditsReport({"from":"2026-09-01","to":"2026-09-30"})`; note hourly refresh.
- "Show my credit usage since October 1, 2026" → `GetCreditsReport({"from":"2026-10-01"})`.
- "Show my all-time credit usage" → `GetCreditsReport({})`.
- "Show my balance and credit usage for September 2026" → balance `{}` plus the September report; identify the balance as current, not the balance at September's end.

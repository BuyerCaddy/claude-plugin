# Credits: balance and usage

Source: public OpenAPI https://api.salescaddy.ai/schema.yaml, checked 2026-10-01.
These tools read account data using the connected caller's credentials; they do not top up or transfer credits.

## GetCreditsBalance
GET /api/credits/balance. Arguments: {} for the connected account.
Optional {"onBehalfOfUser":"user@example.com"} forwards X-On-Behalf-Of-User.
Only use an explicitly requested user identity that the caller is authorized to access; the API decides access.
The response can contain value, an int64 credit balance. It is a credit count, not money.
Example response: {"value":1200}. Missing value is not zero.

## GetCreditsReport
GET /api/credits/report. Arguments: optional from and to in YYYY-MM-DD format.
Example: {"from":"2026-09-01","to":"2026-09-30"}.
Omit both ({}) for the whole API usage period. A single boundary is allowed by the contract.
Dates must be real calendar dates and from must not be later than to.
The public contract does not specify boundary inclusivity or timezone; do not invent these semantics.
This endpoint has no X-On-Behalf-Of-User parameter. Do not apply balance delegation to the report.
Response fields: count (total credits used in the period), rowCount, details (array of path/count/rowCount).
The contract does not define rowCount units; do not call it a request count or a credit count.
Fields are not marked required. Preserve absent fields; do not manufacture totals or details.
Example response: {"count":30,"rowCount":5,"details":[{"path":"/example","count":30,"rowCount":5}]}.
Reports are updated once an hour, so recent usage may not yet appear. Do not present them as real-time
or use them to infer an exact immediate balance change. Current balance comes from GetCreditsBalance.
Raw JSON preserves int64 values; downstream clients should use lossless parsing for large integers.

## Errors
401: reconnect with valid credentials. 403: caller lacks permission. 400: check arguments.
429: wait before retrying. Network/timeouts/5xx: report the failure; retry later if useful.
Never turn a failed request into a zero balance or empty usage report.

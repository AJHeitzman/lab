# Email Important Summary (API Scaffold)

Workflow file: `email-important-summary-api-scaffold.json`

Purpose:
- Read emails from IMAP
- Classify likely important items by keyword
- Produce a compact summary payload

Required post-import setup in n8n UI:
1. Add IMAP credentials on node `Read Inbox (IMAP)`.
2. Replace `Manual Trigger` with `Schedule Trigger` (for example every 30 minutes) when ready.
3. Add a delivery node after `Classify Important`:
   - Email (`Email Send`) or
   - Slack / Teams / Telegram.
4. Activate workflow.

Security:
- Keep mail provider credentials in n8n credential store.
- Keep API keys/secrets in `.env` and do not commit them.

# Email Important Summary (Gmail v2 Scaffold)

Workflow file: `email-important-summary-api-scaffold.json`

Purpose:
- Read emails from Gmail over IMAP.
- Score likely important messages using keyword and sender signals.
- Produce a concise summary text you can route to email, Slack, or Teams.

## What This Scaffold Does

- Trigger: `Manual Trigger` (safe for testing).
- Read: `Read Inbox (IMAP)`.
- Summarize: `Classify + Summarize Important` code node emits:
  - `scannedCount`
  - `importantCount`
  - `summary` (plain text summary block)
  - `importantMessages` (top scored message details)

## Required Setup In n8n UI

1. Open the workflow and set credentials on `Read Inbox (IMAP)`.
2. For Gmail, use these IMAP settings:
   - Host: `imap.gmail.com`
   - Port: `993`
   - SSL/TLS: enabled
   - Username: your full Gmail address
   - Password: Gmail app password (not your normal account password)
3. Execute once with `Manual Trigger` and confirm output from the code node.
4. Add your delivery node after `Classify + Summarize Important`:
   - `Email Send` (SMTP/Gmail), or
   - Slack / Teams / Telegram.
5. Replace `Manual Trigger` with `Schedule Trigger` when ready (for example, every 30 minutes).
6. Activate workflow.

## Suggested Hardening

- Restrict IMAP read scope to recent/unseen mail where possible.
- Keep credentials only in n8n credential store.
- Avoid committing provider secrets to repo files.

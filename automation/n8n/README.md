# n8n API Workflows

This folder stores API-managed n8n workflow artifacts for repeatable automation setup.

## Layout

- `scripts/export-workflows.ps1`: export all workflows from n8n API into `workflows/exports/`
- `scripts/import-workflow.ps1`: create a workflow in n8n from a JSON file
- `workflows/exports/`: timestamped workflow exports from live n8n
- `workflows/templates/`: curated workflow templates checked into git

## Requirements

- `.env` at repo root with `N8N_API_KEY`
- Network access to n8n API (`http://192.168.1.80:31789` by default)

## Export all workflows

```powershell
.\automation\n8n\scripts\export-workflows.ps1
```

## Import one workflow JSON

```powershell
.\automation\n8n\scripts\import-workflow.ps1 -InputFile .\automation\n8n\workflows\templates\email-important-summary-api-scaffold.json
```

## Notes

- Keep secrets in `.env` only; do not embed credentials in workflow JSON files.
- Workflow JSON files in this repo are intended as infrastructure-as-code style workflow definitions.

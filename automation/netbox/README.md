# NetBox Automation

This folder contains helpers for syncing local inventory artifacts into NetBox.

## Scripts

- `scripts/sync-network-devices-to-netbox.ps1`

## CSV to NetBox Sync

The sync script reads `network_devices.csv` and upserts each usable host into NetBox IPAM as an `ipam/ip-addresses` object.

Behavior:
- Uses `NETBOX_ADMIN_API_TOKEN` from `.env`.
- Ensures import tag `network-csv-import` exists.
- Ensures discovered `/24` prefixes exist.
- Upserts IPs idempotently (`created` on first run, `updated` on reruns).
- Stores discovery metadata in `comments`.

Run:

```powershell
.\automation\netbox\scripts\sync-network-devices-to-netbox.ps1
```

Optional dry run:

```powershell
.\automation\netbox\scripts\sync-network-devices-to-netbox.ps1 -WhatIf
```

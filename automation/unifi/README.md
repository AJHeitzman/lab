# UniFi Automation

This folder stores scripts to ingest UniFi (UDM Pro / UniFi Network Integration API) inventory and sync it into NetBox.

## Scripts

- `scripts/fetch-unifi-inventory.ps1`
- `scripts/sync-unifi-to-netbox.ps1`

## Requirements

- `.env` contains:
  - `UDM_PRO_API_KEY`
  - `UDM_PRO_HOST` (optional, defaults to `192.168.1.1`)
  - `NETBOX_ADMIN_API_TOKEN`
- UDM Integration API reachable at `https://<UDM_PRO_HOST>/proxy/network/integration/v1/...`

## Fetch Inventory

```powershell
.\automation\unifi\scripts\fetch-unifi-inventory.ps1
```

Outputs:
- `automation/unifi/data/unifi-inventory-latest.json`
- `automation/unifi/data/unifi-inventory-<timestamp>.json`

## Sync to NetBox

```powershell
.\automation\unifi\scripts\sync-unifi-to-netbox.ps1 -FetchFresh
```

Behavior:
- Ensures tags: `unifi`, `unifi-device`, `unifi-client`
- Upserts UniFi infrastructure devices into `dcim/devices`
- Sets UDM primary management IP from `UDM_PRO_HOST` when UniFi device API only reports public WAN IP
- Upserts private-lan UniFi client IPs as NetBox IP address records (conservative updates; skips assigned infrastructure IPs)

## Notes

- The UniFi local API key uses header `X-API-Key` (not `Authorization: Bearer`).
- Client records are synced at IP metadata level; they are not modeled as NetBox Device/VM objects by default.

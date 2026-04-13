# NetBox Automation

This folder contains helpers for syncing local inventory artifacts into NetBox.

## Scripts

- `scripts/sync-network-devices-to-netbox.ps1`
- `scripts/sync-netbox-assets-from-csv.ps1`

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

## CSV to NetBox Device/VM Sync

The asset sync script builds inventory objects from curated rows in `network_devices.csv`:

- Creates/updates `dcim/devices` for physical systems.
- Creates/updates `virtualization/virtual-machines` for virtual guests.
- Creates management interfaces and links `ipam/ip-addresses`.
- Sets each object's `primary_ip4`.

Current classification defaults in script:

- `csgsw01` style switch rows -> Device (`Network Switch`)
- `oma01rpicls*` worker/master rows -> Device (`k3s Worker` / `k3s Control Plane`)
- `lab-vm-host` workstation/VMware host rows -> Device (`Hypervisor Host`)
- `rancherweb01` VM rows -> Virtual Machine (cluster `homelab-vms`)

Run:

```powershell
.\automation\netbox\scripts\sync-netbox-assets-from-csv.ps1
```

Optional include hostnamed rows even without `Name`:

```powershell
.\automation\netbox\scripts\sync-netbox-assets-from-csv.ps1 -IncludeHostnameOnly
```

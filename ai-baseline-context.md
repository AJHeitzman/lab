# Home Lab AI Baseline Context

Last updated: 2026-04-12 17:35 (America/Chicago)

## Purpose

This repository is the baseline operational context for the home lab. It is intended to be AI-ingestable and kept current as infrastructure changes.

## Source of Truth Files

- `network_devices.csv`: canonical network inventory and device metadata.
- `.env`: credentials and secrets (never commit to git).
- `k8s/helm/*` and `k8s/manifests/*`: deployment definitions for lab services.

## Repo Layout

```text
lab/
  ai-baseline-context.md
  network_devices.csv
  .env                      # gitignored (secrets)
  .gitignore
  .kubeconfig-192.168.1.80.yaml
  k8s/
    helm/
      argocd/
      cert-manager/
      n8n/
      netbox/
      external-secrets/
      openbao/              # legacy values; chart currently incompatible with k3s 1.28
    manifests/
      openbao/
        openbao-dev.yaml
      external-secrets/
        openbao/
          store-and-sample.yaml
```

## Network Inventory Model (`network_devices.csv`)

Current columns:

- `IPAddress`
- `HostOctet`
- `UsableHost`
- `Reachable` (ICMP perspective)
- `LatencyMs`
- `Hostname`
- `CheckedAt`
- `Name`
- `Description`
- `Notes`
- `CredentialRef` (keys in `.env`)
- `MgmtReachable`
- `LastUpdated`

### Update Rules

1. Keep `network_devices.csv` as inventory source of truth.
2. Update `Name`, `Description`, `Notes`, and `CredentialRef` when a device is identified.
3. Store only credential key references in CSV/Markdown.
4. Include infra outside `192.168.1.0/24` when relevant (k3s workers currently in `192.168.0.0/24`).
5. Update `LastUpdated` on every manual edit.

## Current Environment Facts

### Network

- Primary LAN: `192.168.1.0/24`
- Gateway/router: `192.168.1.1`
- Cisco switch mgmt: `192.168.1.2/24` (migrated from `192.168.0.2/24`)

### Cisco Switch

- Device: Cisco Catalyst 2960X 48-port PoE (`csgsw01`)
- Management SVI: `Vlan1 = 192.168.1.2/24`
- Default gateway: `192.168.1.1`
- Change executed over USB console and saved with `write memory`.

### k3s Cluster

- Control-plane: `oma01rpicls01mstr01` (`192.168.1.80`)
- Control-plane status: `Ready`
- k3s upgraded on 2026-04-12: `v1.28.8+k3s1` -> `v1.28.15+k3s1`
- OS package updates applied on control-plane (Debian 12 + Raspberry Pi package refresh)

Workers (all currently `NotReady`):

- `oma01rpicls01wknd01` (`192.168.0.181`)
- `oma01rpicls01wknd02` (`192.168.0.182`)
- `oma01rpicls01wknd03` (`192.168.0.183`)
- `oma01rpicls01wknd04` (`192.168.0.184`)

Worker recovery note:

- Workers remained unreachable even after adding a temporary secondary address (`192.168.0.250/24`) to master NIC for direct L2 reachability testing.
- This indicates the workers are likely offline and/or still isolated on old addressing without path back to master.

### Rancher

- Rancher VM host: `rancherweb01` (`192.168.1.79`)
- Rancher webhook issue fixed on 2026-04-12:
  - `rancher-webhook` pod now healthy on master
  - service endpoints are populated
  - namespace creation admission works again
- Deployment pinned to master node selector to avoid scheduling back onto unreachable worker nodes.

## Platform Services (Live)

### n8n

- Namespace: `n8n`
- Service: NodePort `31789`
- URL: `http://192.168.1.80:31789`
- HTTP mode kept intentionally (`N8N_SECURE_COOKIE=false`) for current LAN-only bootstrap.

### NetBox (IPAM)

- Namespace: `netbox`
- Helm chart: `netbox/netbox` (`8.0.29`)
- Service: NodePort `32081`
- URL: `http://192.168.1.80:32081/login/`
- Worker wait-for-backend init was disabled in values to avoid rollout deadlock during first bootstrap.

### OpenBao (Secrets backend)

- Namespace: `openbao`
- Deployed via manifest (`k8s/manifests/openbao/openbao-dev.yaml`)
- Service: NodePort `32000`
- URL/API: `http://192.168.1.80:32000`
- Mode: `dev` (lab bootstrap only, not production-safe)

### External Secrets Operator (ESO)

- Namespace: `external-secrets`
- Helm chart: `external-secrets/external-secrets` version `0.10.7`
- Reason for version pin: compatible with current k3s/k8s level and avoids CRD validation issues seen with newer release.
- PushSecret processing disabled (`processPushSecret=false`) to match CRD selection.

### OpenBao + ESO integration

- `ClusterSecretStore`: `openbao-store`
- Demo `ExternalSecret`: `default/openbao-sample-secret`
- Synced secret output: `default/demo-from-openbao`
- Vault endpoint in store: `http://openbao.openbao.svc.cluster.local:8200`
- Manifest path: `k8s/manifests/external-secrets/openbao/store-and-sample.yaml`

### Argo CD (GitOps)

- Namespace: `argocd`
- Helm chart: `argo/argo-cd` (`9.4.18`)
- Service: NodePort `32090` (HTTP)
- URL: `http://192.168.1.80:32090`
- Local admin credentials are stored in `.env` as `ARGOCD_ADMIN_USER` and `ARGOCD_ADMIN_PASSWORD`.

### cert-manager

- Namespace: `cert-manager`
- Helm chart: `jetstack/cert-manager` (`v1.19.4`)
- CRDs installed via chart values
- Current state: deployed and ready; no issuer configured yet.

## Credential Handling

Credentials are stored in `.env` and referenced by key name only.

Current key groups include:

- `SWITCH_CISCO_2960_*`
- `K3S_MASTER_*`
- `RANCHERWEB01_*`
- `VM_HOST_IP`
- `N8N_*`
- `NETBOX_*`
- `OPENBAO_ROOT_TOKEN`
- `ARGOCD_ADMIN_*`

`.env` is excluded by `.gitignore`.

## Operational Notes for Future AI Agents

1. Load inventory context from `network_devices.csv` first.
2. Resolve device credentials via `.env` key references from `CredentialRef`.
3. Validate management reachability before attempting remote ops.
4. For k3s changes, verify Rancher webhook health first (`cattle-system/rancher-webhook`).
5. Keep service definitions in `k8s/` aligned with runtime state after every change.

## Next Actions

- Recover the 4 worker Pis (`192.168.0.181-184`) and restore `Ready` state.
- After worker recovery, run OS/k3s patch upgrades on each worker to align with control-plane (`v1.28.15+k3s1`).
- Replace OpenBao dev mode with persistent/non-dev configuration when ready.

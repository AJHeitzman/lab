# OpenBao Deployment

Namespace: `openbao`
Deployment method: Kubernetes manifest (not Helm chart)

## Why Manifest-Based

Current OpenBao Helm chart versions require Kubernetes `>=1.30.0`, while this cluster is currently on `k3s v1.28.x`.

## Access

- URL/API: `http://192.168.1.80:32000`

## Mode

Current setup uses OpenBao `dev` mode for rapid bootstrap.

## Files

- `k8s/manifests/openbao/openbao-dev.yaml`
- `k8s/manifests/external-secrets/openbao/store-and-sample.yaml`

## Important

Dev mode is not production-safe. It is acceptable for lab bootstrap only.

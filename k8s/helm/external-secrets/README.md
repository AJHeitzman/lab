# External Secrets Operator Deployment

Chart: `external-secrets/external-secrets`
Version: `0.10.7`
Namespace: `external-secrets`

## Why This Version

Newer chart versions worked poorly on this k3s baseline (`v1.28.x`) due CRD validation and push-secret related issues.

## Key Settings

- `installCRDs: true`
- `crds.createPushSecret: false`
- `processPushSecret: false`

## Included OpenBao Integration Manifest

- `k8s/manifests/external-secrets/openbao/store-and-sample.yaml`
  - `ClusterSecretStore` -> OpenBao in `openbao`
  - demo `ExternalSecret` -> `default/demo-from-openbao`

## Deploy

```bash
helm upgrade --install external-secrets external-secrets/external-secrets \
  --version 0.10.7 \
  -n external-secrets --create-namespace \
  -f k8s/helm/external-secrets/values.yaml
```

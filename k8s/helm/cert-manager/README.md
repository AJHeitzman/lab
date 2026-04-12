# cert-manager Deployment (Helm)

Chart: `jetstack/cert-manager`
Version: `v1.19.4`
Namespace: `cert-manager`

## Deploy

```bash
helm upgrade --install cert-manager jetstack/cert-manager \
  --version v1.19.4 \
  -n cert-manager --create-namespace \
  -f k8s/helm/cert-manager/values.yaml
```

## Notes

- `installCRDs: true` is enabled for first install.
- Prometheus metrics scraping is disabled for now to keep resource use low.

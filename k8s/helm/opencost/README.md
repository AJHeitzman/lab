# OpenCost Deployment (Helm)

Chart: `opencost/opencost`
Version: `2.5.12`
Namespace: `opencost`

## Access

- URL: `http://192.168.1.80:32093`

## Deploy

```bash
helm upgrade --install opencost opencost/opencost \
  --version 2.5.12 \
  -n opencost --create-namespace \
  -f k8s/helm/opencost/values.yaml
```

## Notes

- Configured to scrape Prometheus in `observability` namespace via `prometheus-server` service.

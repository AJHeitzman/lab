# Loki Stack Deployment (Helm)

Chart: `grafana/loki-stack`
Version: `2.10.3`
Namespace: `observability`

## Deploy

```bash
helm upgrade --install loki grafana/loki-stack \
  --version 2.10.3 \
  -n observability --create-namespace \
  -f k8s/helm/loki/values.yaml
```

## Notes

- Includes `promtail` for node/pod log shipping.
- Grafana subchart is disabled (standalone Grafana is deployed separately).

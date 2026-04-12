# Prometheus Deployment (Helm)

Chart: `prometheus-community/prometheus`
Version: `29.2.0`
Namespace: `observability`

## Access

- URL: `http://192.168.1.80:32091`

## Deploy

```bash
helm upgrade --install prometheus prometheus-community/prometheus \
  --version 29.2.0 \
  -n observability --create-namespace \
  -f k8s/helm/prometheus/values.yaml
```

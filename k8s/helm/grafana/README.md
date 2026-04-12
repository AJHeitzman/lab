# Grafana Deployment (Helm)

Chart: `grafana/grafana`
Version: `10.5.15`
Namespace: `observability`

## Access

- URL: `http://192.168.1.80:32030`

## Deploy

```bash
helm upgrade --install grafana grafana/grafana \
  --version 10.5.15 \
  -n observability --create-namespace \
  -f k8s/helm/grafana/values.yaml \
  --set adminPassword=$GRAFANA_ADMIN_PASSWORD
```

## Notes

- Datasources for Prometheus and Loki are provisioned via values.
- Store `GRAFANA_ADMIN_PASSWORD` in `.env`.

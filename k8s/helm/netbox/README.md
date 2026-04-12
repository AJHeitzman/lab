# NetBox Deployment (Helm)

Chart: `netbox/netbox`
Version: `8.0.29`
Namespace: `lab-infra`

## Access

- URL: `http://192.168.1.80:32081/login/`

## Values + Secrets

Values file:

- `k8s/helm/netbox/values.yaml`

Secret overrides from `.env`:

- `NETBOX_SUPERUSER_USERNAME`
- `NETBOX_SUPERUSER_EMAIL`
- `NETBOX_SUPERUSER_PASSWORD`
- `NETBOX_SECRET_KEY`

## Deploy

```bash
helm upgrade --install netbox netbox/netbox \
  --version 8.0.29 \
  -n lab-infra --create-namespace \
  -f k8s/helm/netbox/values.yaml \
  --set superuser.name=$NETBOX_SUPERUSER_USERNAME \
  --set superuser.email=$NETBOX_SUPERUSER_EMAIL \
  --set superuser.password=$NETBOX_SUPERUSER_PASSWORD \
  --set secretKey=$NETBOX_SECRET_KEY
```

## Note

`worker.waitForBackend.enabled` is set to `false` to avoid init deadlock during first bootstrap on this cluster.
# Argo CD Deployment (Helm)

Chart: `argo/argo-cd`
Version: `9.4.18`
Namespace: `argocd`

## Access

- URL: `http://192.168.1.80:32090`
- Service: `argocd-server` (`NodePort 32090`)

## Deploy

```bash
helm upgrade --install argocd argo/argo-cd \
  --version 9.4.18 \
  -n argocd --create-namespace \
  -f k8s/helm/argocd/values.yaml
```

## Get Initial Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Username is `admin`.

## Notes

- `server.insecure=true` is set for HTTP-only LAN bootstrap.
- `dex` and `notifications` are disabled to reduce footprint on the single ready node.

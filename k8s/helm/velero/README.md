# Velero Deployment (Helm)

Chart: `vmware-tanzu/velero`
Version: `12.0.0`
Namespace: `velero`

## Prepare Credentials Secret

```bash
kubectl -n velero create secret generic velero-credentials \
  --from-literal=cloud="[default]
aws_access_key_id=$VELERO_MINIO_ACCESS_KEY
aws_secret_access_key=$VELERO_MINIO_SECRET_KEY" \
  --dry-run=client -o yaml | kubectl apply -f -
```

## Deploy

```bash
helm upgrade --install velero vmware-tanzu/velero \
  --version 12.0.0 \
  -n velero --create-namespace \
  -f k8s/helm/velero/values.yaml
```

## Notes

- Backup target: MinIO (`velero-minio.velero.svc.cluster.local:9000`)
- Snapshotting is disabled (`snapshotsEnabled: false`), file-system backups use node-agent.

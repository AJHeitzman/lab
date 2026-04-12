# MinIO Deployment (Helm, Velero backend)

Chart: `minio/minio`
Version: `5.4.0`
Namespace: `velero`

## Deploy

```bash
helm upgrade --install velero-minio minio/minio \
  --version 5.4.0 \
  -n velero --create-namespace \
  -f k8s/helm/minio/values.yaml \
  --set rootUser=$VELERO_MINIO_ACCESS_KEY \
  --set rootPassword=$VELERO_MINIO_SECRET_KEY
```

## Notes

- Creates bucket `velero` at startup.
- Used as in-cluster object storage target for Velero backups.

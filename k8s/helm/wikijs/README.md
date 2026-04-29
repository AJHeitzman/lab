# Wiki.js Helm Values

This values file deploys Wiki.js to the `wikijs` namespace and points it to the external PostgreSQL VM (`lab-pgsql01`).

Deploy command:

```powershell
helm upgrade --install wikijs requarks/wiki `
  --namespace wikijs `
  --create-namespace `
  -f k8s/helm/wikijs/values.yaml
```

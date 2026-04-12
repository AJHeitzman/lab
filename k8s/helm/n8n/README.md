# n8n Helm Deployment

This folder contains a local Helm chart for deploying `n8n` to the k3s cluster.

## Deploy

```powershell
$envPath = "C:\Users\adamj\SourceControl\lab\.env"
$kcfg = "C:\SourceControl\youtube_downloader\k3s-remote-kubeconfig.yaml"

$envMap = @{}
Get-Content $envPath | ForEach-Object {
  if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
  if ($_ -match '^\s*([^=]+)=(.*)$') { $envMap[$matches[1]] = $matches[2] }
}

$tmpVals = Join-Path $env:TEMP "n8n-secrets-values.yaml"
@"
secrets:
  basicAuthUser: "$($envMap['N8N_BASIC_AUTH_USER'])"
  basicAuthPassword: "$($envMap['N8N_BASIC_AUTH_PASSWORD'])"
  encryptionKey: "$($envMap['N8N_ENCRYPTION_KEY'])"
"@ | Set-Content -Path $tmpVals -Encoding UTF8

helm upgrade --install n8n .\k8s\helm\n8n `
  --namespace default `
  --kubeconfig $kcfg `
  -f .\k8s\helm\n8n\values.yaml `
  -f $tmpVals
```

## Access

- URL: `http://192.168.1.80:31789`
- Auth: values from `.env` (`N8N_BASIC_AUTH_USER` / `N8N_BASIC_AUTH_PASSWORD`)
- HTTP mode is supported by setting `N8N_SECURE_COOKIE=false` in the deployment.

## Verify

```powershell
kubectl --kubeconfig C:\SourceControl\youtube_downloader\k3s-remote-kubeconfig.yaml -n default get deploy,pods,svc,pvc | findstr n8n
```

## Current namespace note

`n8n` is currently deployed in `default` because Rancher webhook issues blocked creating a new namespace during deployment.

## TLS note

If you move n8n behind HTTPS later (Ingress + cert), switch:

- `env.externalProtocol` to `https`
- `env.secureCookie` to `true`

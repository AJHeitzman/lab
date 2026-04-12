# Falco Deployment (Helm)

Chart: `falcosecurity/falco`
Version: `8.0.2`
Namespace: `falco`

## Deploy

```bash
helm upgrade --install falco falcosecurity/falco \
  --version 8.0.2 \
  -n falco --create-namespace \
  -f k8s/helm/falco/values.yaml
```

## Notes

- Driver mode is pinned to legacy `ebpf` because `modern_ebpf` failed on this Raspberry Pi kernel build.
- Falco runs as a DaemonSet (one pod per schedulable node).

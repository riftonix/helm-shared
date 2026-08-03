# AI Inference Mesh

Inference setup with mesh ingress, KServe, Knative, Vault secrets, and Prometheus monitoring.

## Used Charts
- `appchart`
- `istio`
- `kserve`
- `knative`
- `vault-secret-operator`
- `kube-prometheus-stack`

## Used Technologies
- Istio Gateway, VirtualService, AuthorizationPolicy, DestinationRule
- KServe InferenceService
- Knative Service
- VaultConnection, VaultAuth, VaultStaticSecret
- ServiceMonitor, PodMonitor, PrometheusRule

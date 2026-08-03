# Platform Baseline App

Baseline platform case for an application with a primary ingress endpoint through Istio Gateway, a Gateway certificate, Vault secrets, Prometheus Operator monitoring, KEDA autoscaling, and a regular application Deployment.

## Used Charts
- `appchart`
- `istio`
- `cert-manager`
- `vault-secret-operator`
- `kube-prometheus-stack`
- `keda`

## Used Technologies
- Istio Gateway, VirtualService, and DestinationRule
- cert-manager Certificate and ClusterIssuer
- Vault Static Secret
- Prometheus ServiceMonitor and PrometheusRule
- KEDA ScaledObject
- Kubernetes Deployment and Service

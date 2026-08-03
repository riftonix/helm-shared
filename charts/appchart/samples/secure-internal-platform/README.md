# Secure Internal Platform

Internal platform case with a service behind Istio mTLS, JWT auth, secret delivery from Vault, and Prometheus monitoring.

## Used Charts
- `appchart`
- `istio`
- `vault-secret-operator`
- `kube-prometheus-stack`

## Used Technologies
- Istio AuthorizationPolicy and RequestAuthentication
- Vault Static Secret
- Prometheus Operator

# Install and Configure Tyk Operator

1. Switch to correct cluster
```
kubectx staging
kubectx production
```

2. Install cert-manager
```
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml
```

3. Install Operator CRDs
```
kubectl apply -f 'https://github.com/TykTechnologies/tyk-operator/blob/master/helm/crds/crds.yaml?raw=true'
```

4. Install tyk operator

```
kubectl create namespace tyk-operator-system
kubectl create secret -n tyk-operator-system generic tyk-operator-conf \
  --from-literal "TYK_AUTH=${APISecret}" \
  --from-literal "TYK_ORG=org" \
  --from-literal "TYK_MODE=ce" \
  --from-literal "TYK_URL=http://gateway-svc-tyk-oss-tyk-gateway.tyk.svc.cluster.local:8080" \
  --from-literal "TYK_TLS_INSECURE_SKIP_VERIFY=true"
helm install tyk-operator tyk-helm/tyk-operator -n tyk-operator-system

```
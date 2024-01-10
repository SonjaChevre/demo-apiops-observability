# Install and Configure Tyk Gateway OSS

This is simple instruction to install Tyk Gateway (OSS deployment).

```
NAMESPACE=tyk-oss
APISecret=BananaSplit42

helm upgrade tyk-redis oci://registry-1.docker.io/bitnamicharts/redis -n $NAMESPACE --create-namespace --install --set image.tag=6.2.13

helm upgrade tyk-oss tyk-helm/tyk-oss -n $NAMESPACE --create-namespace \
  --install \
  --set global.secrets.APISecret="$APISecret" \
  --set global.redis.addrs="{tyk-redis-master.$NAMESPACE.svc:6379}" \
  --set global.redis.passSecret.name=tyk-redis \
  --set global.redis.passSecret.keyName=redis-password
```


To quickly test everything is ok, you can port-forward Tyk Gateway pod:
```
kubectl port-forward --namespace tyk-oss service/gateway-svc-tyk-oss-tyk-gateway 8080:8080
curl localhost:8080/hello
```

References: https://github.com/TykTechnologies/tyk-charts/tree/main/tyk-oss 
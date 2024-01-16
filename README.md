# Deploy Fast, Without Breaking Things: Level Up APIOps With OpenTelemetry

This is a demo project for the talk "Deploy Fast, Without Breaking Things: Level Up APIOps With OpenTelemetry", based on https://github.com/caroltyk/tyk-cicd-demo2.


## Deploying demo application and API definition with Helm and ArgoCD

### Staging environment setup

First, setup your staging environment. In this demo, we will assume 2 environments (staging and prod).

#### Create a local Kubernetes cluster

```
minikube start -p staging
```

Later, to see how list the clusters:
```
minikube profile list
```

Then to switch cluster use:
```
kubectx staging
kubectx production
```

#### Install ArgoCD

Here are the commands needed to Install ArgoCD on your cluster. Refer to [ArgoCD documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/) for more details. 

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

```
kubectl port-forward svc/argocd-server -n argocd 9080:443
```

[Download Argo CD CLI](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli) and retrieve default admin password:

```
argocd admin initial-password -n argocd
```


#### Configure Tyk, Tyk Operator, go-httbin demo API and all the required dependency

Tyk:

```
kubectl apply -f ./staging/argocd/application-go-httpbin.yaml
kubectl apply -f ./staging/argocd/application-redis.yaml
kubectl apply -f ./staging/argocd/application-tyk-gateway-conf.yaml
kubectl apply -f ./staging/argocd/application-tyk-gateway.yaml
kubectl apply -f ./staging/argocd/application-cert-manager.yaml
```

```
kubectl create secret -n tyk generic tyk-operator-conf \
  --from-literal "TYK_AUTH=BananaSplit42" \
  --from-literal "TYK_ORG=org" \
  --from-literal "TYK_MODE=ce" \
  --from-literal "TYK_URL=http://gateway-svc-tyk-gateway-application.tyk.svc.cluster.local:8080" \
  --from-literal "TYK_TLS_INSECURE_SKIP_VERIFY=true"
```

```
kubectl apply -f ./staging/argocd/application-tyk-operator.yaml
kubectl apply -f ./staging/argocd/application-api-definitions.yaml
```

Try it out:

```
kubectl port-forward svc/gateway-svc-tyk-gateway-application -n tyk 8080:8080
```

* Tyk health endpoint: http://localhost:8080/hello
* go-httpbin: http://localhost:8080/httpbin/

#### Configure OpenTelemetry Collector and Jaeger


```
kubectl apply -f ./staging/argocd/application-opentelemetry-collector.yaml
kubectl apply -f ./staging/argocd/application-jaeger-operator.yaml
kubectl apply -f ./staging/argocd/application-jaeger-all-in-one.yaml
```

Try it out:

```
kubectl port-forward svc/jaeger-all-in-one-query -n observability 16686:16686
```

* Make a couple of calls to: http://localhost:8080/httpbin/get
* Look at the distributed traces in Jaeger: http://localhost:16686


#### Configure Tracetest

```
kubectl apply -f ./staging/argocd/application-tracetest.yaml
```

Try it out:

```
kubectl port-forward svc/tracetest -n tracetest 11633:11633
```

Run a test:

Tracetest YAML test definition

```yaml
type: Test
spec:
  id: BtGGxD5SR
  name: Test HTTPBin
  trigger:
    type: http
    httpRequest:
      method: GET
      url: http://gateway-svc-tyk-gateway-application.tyk.svc.cluster.local:8080/httpbin/get
      headers:
      - key: Content-Type
        value: application/json
```

![Tracetest test](https://res.cloudinary.com/djwdcmwdz/image/upload/v1705323131/Conferences/fosdem2024/localhost_11633_test_btVZdD5IR_run_3_trace_kvtzuq.png)


TODO expose directly on localhost, not having to use port redirect


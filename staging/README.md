# Set-up Staging environment

## Switch to the staging cluster

```
kubectx staging
```

## Install ArgoCD

Here are the commands needed to Install ArgoCD on your cluster. Refer to [ArgoCD documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/) for more details. 

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Log in to ArgoCD

Forward the local port 9080 to ArgoCD's secure port (443) to access ArgoCD UI interface:

```
kubectl port-forward svc/argocd-server -n argocd 9080:443
```

[Download and install Argo CD CLI](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli) and retrieve default admin password:

```
argocd admin initial-password -n argocd
```


## Create ArgoCD applications

```
kubectl apply -f ./staging/argocd/application-apis.yaml
kubectl apply -f ./staging/argocd/application-observability.yaml
```

After following the steps below, this is how your ArgoCD instance should look like on the staging cluster (wait for all applications to be synchronized): 
![ArgoCD in staging](./../images/APIOps-Staging-Argo-CD.png)

## Try it out

### Tyk

Forward the port 8080:

```
kubectl port-forward svc/gateway-svc-tyk-gateway-application -n tyk 8080:8080
```

* Tyk health endpoint: http://localhost:8080/hello
* go-httpbin: http://localhost:8080/httpbin/get

### Jaeger

Forward the port 16686:

```
kubectl port-forward svc/jaeger-all-in-one-query -n observability 16686:16686
```

* Jaeger: http://localhost:16686

### Testing with Tracetest

Forward the port: 11633

```
kubectl port-forward svc/tracetest -n tracetest 11633:11633
```

* Tracetest: http://localhost:11633

#### Run a test manually:

Tracetest YAML test definition

`httpbin` - HTTP API

```yaml
type: Test
spec:
  id: nf4f055Sg
  name: Test HTTPBin
  trigger:
    type: http
    httpRequest:
      method: GET
      url: http://gateway-svc-tyk-gateway-application.tyk.svc.cluster.local:8080/httpbin/get
      headers:
      - key: Content-Type
        value: application/json
  specs:
  - selector: span[tracetest.span.type="http"]
    name: "All HTTP Spans: Status code is 200"
    assertions:
    - attr:http.status_code = 200
  - selector: span[tracetest.span.type="http" name="HTTP GET" http.method="GET"]
    name: Validate API performance is below 200ms
    assertions:
    - attr:tracetest.span.duration  <  200ms
```

`trevorblades` - GraphQL API

```yaml
type: Test
spec:
  id: 2jKmB7pIR
  name: Test GraphQL
  trigger:
    type: http
    httpRequest:
      method: POST
      url: http://gateway-svc-tyk-gateway-application.tyk.svc.cluster.local:8080/trevorblades
      body: "{\n  \"query\": \"{ country { name } }\"\n}"
      headers:
      - key: Content-Type
        value: application/json
```

![Tracetest test](https://res.cloudinary.com/djwdcmwdz/image/upload/v1705323131/Conferences/fosdem2024/localhost_11633_test_btVZdD5IR_run_3_trace_kvtzuq.png)

#### Running automated integration tests

The integration tests (configured with a [hook](https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/) under [./application-integration-tracetest.yaml](./application-integration-tracetest.yaml) will run after every deployment changes.

#### Update the integration tests

Build the Docker image for the hook.

```
cd ./staging/tracetest
docker build . -t <your_username>/demo-apiops-observability
```

Push the Docker image to Docker Hub.

```
docker push <your_username>/demo-apiops-observability:latest
```

(Optional): Use a prebuilt sample image:

```
adnanrahic/demo-apiops-observability:latest
```

Update the hook under [./hook-integration-tracetest.yaml](./hook-integration-tracetest.yaml)

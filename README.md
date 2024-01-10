# Deploy Fast, Without Breaking Things: Level Up APIOps With OpenTelemetry

This is a demo project for the talk "Deploy Fast, Without Breaking Things: Level Up APIOps With OpenTelemetry", based on https://github.com/caroltyk/tyk-cicd-demo2.


## Deploying demo application and API definition with Helm and ArgoCD

### Staging environment setup

First, setup your staging environment. In this demo, we will assume 2 environments (staging and prod).

#### Create a local Kubernetes cluster

```
minikube start -p staging
```

Later, to switch cluster use:
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

retrieve default password
```
argocd admin initial-password -n argocd
```

#### Configure ArgoCD application for go-httpbin

```
kubectl apply -f ./argocd/application-go-httpbin.yaml
kubectl apply -f ./argocd/application-redis.yaml
```

#### Install Tyk

Follow [`gateway-configs`](./gateway-configs/) to install Tyk.

3. Install Tyk Operator

Follow [`operator-configs`](./operator-configs/) to install Tyk Operator and configure OperatorContext to connect to different Tyk environments.

4. Install ArgoCD

[Install ArgoCD](https://argo-cd.readthedocs.io/en/stable/getting_started/) on your cluster.

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

```
kubectl port-forward svc/argocd-server -n argocd 8081:443
```

retrieve default password
```
argocd admin initial-password -n argocd
```

5. Example HTTP API - See [httpbin](./httpbin/)


6. To enable GitOps management of your application and APIs, create some ArgoCD Applications, e.g.:

```
kubectl apply -f argocd/httpbin-applicationset.yaml
```

This will automatically deploy applications to multiple environments during ArgoCD synchronization.
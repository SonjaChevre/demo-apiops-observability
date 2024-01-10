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

retrieve default password (you might need to open another terminal window for that):

```
argocd admin initial-password -n argocd
```


#### Configure ArgoCD applications

```
kubectl apply -f ./argocd/application-go-httpbin.yaml
kubectl apply -f ./argocd/application-redis.yaml
kubectl apply -f ./argocd/application-tyk.yaml
kubectl apply -f ./argocd/application-cert-manager.yaml
```
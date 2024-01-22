# Deploy Fast, Without Breaking Things: Level Up APIOps With OpenTelemetry

This is a demo project for the talk "Deploy Fast, Without Breaking Things: Level Up APIOps With OpenTelemetry" from [Sonja Chevre](https://www.linkedin.com/in/sonjachevre/) and [Adnan Rahić](https://www.linkedin.com/in/adnanrahic/).

This demo started as a fork from https://github.com/caroltyk/tyk-cicd-demo2. Thanks Carol for the inspiration! This demo is not configured for running in a real production environment but just to explore what could be possible. 

Follow along to deploy 2 environments with ArgoCD, Tyk, OpenTelemetry, Jaeger and Tracetest. 

## Create local Kubernetes cluster for staging and production

 In this demo, we will assume 2 environments (staging and prod) running in [minikube](https://minikube.sigs.k8s.io/docs/start/):

```
minikube start -p staging
minikube start -p production
```

Later, to list the clusters:
```
minikube profile list
```

Then to switch cluster use [kubectx](https://github.com/ahmetb/kubectx):
```
kubectx staging
kubectx production
```

## Deploy staging

Follow the steps from [./staging/README.md](./staging/README.md)

## Deploy production

Follow the steps from [./staging/README.md](./production/README.md)
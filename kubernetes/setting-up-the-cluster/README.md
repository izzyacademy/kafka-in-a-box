## Setting up the Environment

First, we need to set up [Docker Desktop](https://www.docker.com/products/docker-desktop) on Windows or Mac OS X. On Linux, there are various commands for [setting up Docker depending on your favorite Linux distribution](https://docs.docker.com/engine/install/ubuntu/)


We can use any of the following options to deploy the Helm Charts:

- Kubernetes via [Docker Desktop](https://www.docker.com/products/kubernetes)
- Kubernetes via [Minikube](https://kubernetes.io/docs/tasks/tools/#minikube)
- Kubernetes via [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- Kubernetes via [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal) (if you prefer to run it in the Cloud)


Once your Kubernetes cluster is up and running you need to set up the [Kubectl client](https://kubernetes.io/docs/tasks/tools/#kubectl) locally and then [install Helm 3](https://helm.sh/docs/intro/install/)


The installation of Docker, Kubernetes, Kube Control (kubectl) and Helm 3 is all we need to get rolling.


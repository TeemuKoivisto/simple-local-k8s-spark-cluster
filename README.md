# Simple Local Kubernetes Spark Cluster

(Almost) OS-agnostic way of installing Spark on your local computer with not too much hassle. Kinda. 😀

It's composed of my old instructions which are scattered as Gists and couple repos. So I'll just put them here and maybe they'll be useful for somebody.

Now that I think about, there was something horribly wrong with setting up local k8s Spark cluster... Was it just that it was impossible? Hmm, can't remember... 

* https://gist.github.com/TeemuKoivisto/5632fabee4915dc63055e8e544247f60
* https://github.com/TeemuKoivisto/kotlin-hello-big-data

**Table of Contents**

<!-- toc -->

- [Simple Local Kubernetes Spark Cluster](#simple-local-kubernetes-spark-cluster)
- [0.0 Prerequisites](#00-prerequisites)
  - [0.1 Docker installation](#01-docker-installation)
  - [0.2 Minikube installation](#02-minikube-installation)
  - [0.3 Helm installation](#03-helm-installation)
- [1.0 Helm Spark-chart installation](#10-helm-spark-chart-installation)
  - [1.1 Creating local volume](#11-creating-local-volume)
  - [2.1 Running a job on the cluster](#21-running-a-job-on-the-cluster)

<!-- tocstop -->

# 0.0 Prerequisites

Kubernetes with probably minikube and Docker + Helm installed locally. So basically you should install first Docker, then minikube (which is a VM for running k8s) and then lastly Helm. I might or might not add instructions here for them.

Also this probably doesn't work on Windows, haven't tried. Possibly with Linux subsystem but it's going to be hard, so be aware.

**Important**: load the helper functions from `spark.sh` with `. spark.sh`.

## 0.1 Docker installation

Well if you can't figure this one out by yourself, I don't think you should be doing this.

## 0.2 Minikube installation

https://kubernetes.io/docs/tasks/tools/install-minikube/

Minikube should install with VirtualBox as default driver which I recommend. When starting minikube we should increase its memory limit since our Hadoop node's pods need at least 2GB: `minikube --memory 4096 --cpus 2 start` (minikube's default is 1GB). 
   
NOTE: actually the Hadoop cluster by default uses about 10GB in memory limits and about 3GB running memory. From what I looked my k8s will overprovision to 300% of its capacity limits but use far less.

## 0.3 Helm installation

https://helm.sh/docs/using_helm/

# 1.0 Helm Spark-chart installation

1. Init Helm if you didn't already: `helm init`
2. Install the Spark-chart by entering `sinstall` or pasting this:
```bash
  helm install \
    --set Zeppelin.Persistence.Config.Enabled=false \
    --set Zeppelin.Persistence.Notebook.Enabled=false \
    --set Zeppelin.ServiceType=NodePort \
    --set Master.ServiceType=NodePort \
    stable/spark
```
3. Open up the k8s dashboard: `minikube dashboard`. You should see your pods initializing. If everything went well they should all have 1/1 pods running.
4. Port-forward the Zeppelin UI pod to localhost to see if it's working: `kubectl port-forward something something`. It should open a Zeppelin notebook on localhost:8500. If it doesn't well, try adding more memory to your Zeppelin cluster. It's ... weird. But I recommend never adding more than half of your total capacity!

## 1.1 Creating local volume

Well because copying our working data to the cluster or downloading it inside the cluster is such a pain in the ass and really a dumb way to do it, we'll use a persistent volume to mount the data without having to copy it around.

There was some major problems with how this worked, and I think I found out a bug from the chart when I did this.

1. Run: `kubectl apply -f my-spark-pv.yml`
2. Then go to the k8s dashboard, and edit the configuration: x
3. stuff

Now you should have your `/k8s-mnt` path mounted to the Spark worker nodes so everything you put there should be synced perfectly between your filesystem and the cluster's.

## 2.1 Running a job on the cluster

To see that all our work wasn't for nothing, let's try running WordCount(?) inside the cluster.

Then do some manipulation using CSV data, PySpark and Pandas? By setting the connection URL on the local notebook to the cluster's? Idk



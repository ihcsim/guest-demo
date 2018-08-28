# guest-demo
This project contains scripts used in the Kubernetes Autoscaling demo on the _Guest_ team's Dev Show day.

## Set-up
The following is the list of software used for this demo:

* [Minikube v0.28.2](https://github.com/kubernetes/minikube/releases/tag/v0.28.2)
* [Hyperkit v0.20180403-17-g3e954c](https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#hyperkit-driver)
* [kubectl v1.10+](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)
* [Go 1.11](https://golang.org/dl/)

## Getting Started
To start up Minikube on Mac OSX:
```
# start with the Hyperkit driver, enable metrics-server, heapster and registry add-ons
$ make start
```
To expose the Minikube's private registry:
```
$ make expose-registry
```
By default, the Minikube's private registry isn't accessible from the host machine. The `expose-registry` Make target creates a `NodePort` service type targeting the registry node, allowing the Docker CLI to push server images tagged as `${minikube_ip}:${node_port}/server` to the private registry.

To build and push the Docker image:
```
# build and push the Docker image to Minikube's local registry
$ make build
$ make push
```

To deploy the server to Minikube:
```
$ make deploy
$ kubectl get po
NAME                          READY     STATUS    RESTARTS   AGE
guest-demo-5df8b875b4-lmhcc   1/1       Running   0          14m
$ kubectl logs guest-demo-5df8b875b4-lmhcc
2018/08/29 03:01:00 Listening at port 8080...
```

To deploy the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/):
```
$ make autoscale
$ kubectl get hpa
NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
guest-demo   Deployment/guest-demo   0%/50%    3         7         3          1m
```

To delete the Minikube k8s cluster:
```
$ make purge
```

## Demo
Demo agenda:
* Deploy webserver.
  * Receives a request and write 1GB of data to `/dev/null`.
* Show pod count.
* Send a single request.
* View server logs.
* Run load tests.
* Wait for pods to scale out.
* Shows load test report.
* Wait for pods to scale in.

The list of commands:
```
$ make start
$ make expose-registry
$ make build
$ make push
$ make deploy
$ kubectl get po
$ kubectl logs -f <pod>
$ make load/single
$ make autoscale
$ kubectl get hpa -w
$ kubectl get po -w
$ make load/large
```

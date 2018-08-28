ifeq ($(shell minikube status --format {{.MinikubeStatus}}), Running)
IMAGE_REPO_HOST := $(shell minikube ip)
MINIKUBE_IP := $(shell minikube ip)
endif

start:
	scripts/minikube.sh

REGISTRY_NODE_PORT ?= 30030
SERVER_NODE_PORT ?= 30050

build:
	@eval $$(minikube docker-env) ; \
	docker build -t $(IMAGE_REPO_HOST):$(REGISTRY_NODE_PORT)/guest-demo .

push:
	@eval $$(minikube docker-env) ; \
	docker push $(IMAGE_REPO_HOST):$(REGISTRY_NODE_PORT)/guest-demo

expose-registry:
	sed s/{{RegistryNodePort}}/$(REGISTRY_NODE_PORT)/g k8s/registry-svc.yaml | kubectl apply -f -

deploy:
	sed 's/{{ServerNodePort}}/$(SERVER_NODE_PORT)/g; s/{{ImageRepoHost}}/$(IMAGE_REPO_HOST)/g; s/{{RegistryNodePort}}/$(REGISTRY_NODE_PORT)/g' k8s/server.yaml | kubectl apply -f -

autoscale:
	kubectl apply -f k8s/hpa.yaml

stop:
	minikube stop

purge:
	minikube delete

load/single:
	curl $(MINIKUBE_IP):$(SERVER_NODE_PORT)

load/large:
	mkdir -p results
	echo "GET http://$(MINIKUBE_IP):$(SERVER_NODE_PORT)/" | vegeta attack -duration=300s | tee results/data.bin | vegeta report
	cat results/data.bin | vegeta plot > results/plot.html

report:
	open results/plot.html

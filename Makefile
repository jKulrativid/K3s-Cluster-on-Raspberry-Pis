install_app:
	kubectl apply -f ./k8s/deployments.yaml
	kubectl apply -f ./k8s/services.yaml

uninstall_app:
	kubectl delete -f ./k8s/services.yaml
	kubectl delete -f ./k8s/deployments.yaml
.DEFAULT_GOAL := help

create: ansible-galaxy-install terraform-validate terraform-get terraform-apply ## Apply Changes

destroy: terraform-destroy								## Destroy infrastructure

terraform-validate:
	terraform validate

terraform-get:
	terraform get

terraform-apply:
	terraform apply
	echo [all] > inventory_ansible_swarm
	terraform output cluster_master_swarm >> inventory_ansible_swarm
	terraform output cluster_node_swarm >> inventory_ansible_swarm
	ansible-playbook ansible.yaml -i inventory_ansible_swarm

terraform-destroy:
	terraform destroy
	rm -rf swarm.token
	rm -rf inventory_ansible_swarm
	rm -rf *.tfstate*
	rm -rf *.retry

ansible-galaxy-install:
	ansible-galaxy install GoContainer.system-update
	ansible-galaxy install AerisCloud.disk
	ansible-galaxy install GoContainer.glusterfs
	ansible-galaxy install GoContainer.docker-local-persist

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Variables
ANSIBLE_INVENTORY_FILE = atlantis-server/ansible/inventory.yml
PRIVATE_KEY = /path/to/your/private-key.pem
ANSIBLE_PLAYBOOK = atlantis-server/ansible/atlantis-playbook.yml

# Terraform Init, Apply, and Get the EC2 Instance IP
.PHONY: terraform
atlantis-infra:
	cd atlantis-server/terraform
	@echo "Initializing Terraform..."
	terraform init
	@echo "Applying Terraform to create Atlantis EC2 instance..."
	terraform apply -auto-approve
	@echo "Fetching EC2 instance IP..."
	terraform output -raw atlantis_server_public_ip > ec2_ip.txt
	@echo "EC2 instance IP saved to ec2_ip.txt"

# Run Ansible with the EC2 Instance IP as input
.PHONY: ansible
atlantis-config:
	cd atlantis-server/ansible
	@echo "Fetching EC2 instance IP from Terraform output..."
	EC2_IP=$$(cat ec2_ip.txt)
	@echo "Running Ansible playbook on EC2 instance with IP: $$EC2_IP..."
	@echo "[atlantis]\n$$EC2_IP ansible_user=ec2-user ansible_ssh_private_key_file=$(PRIVATE_KEY) ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > $(ANSIBLE_INVENTORY_FILE)
	@ansible-playbook -i $(ANSIBLE_INVENTORY_FILE) $(ANSIBLE_PLAYBOOK)

# Clean up EC2 IP file
.PHONY: clean
clean:
	@rm -f ec2_ip.txt $(ANSIBLE_INVENTORY_FILE)
	@echo "Cleaned up temporary files."

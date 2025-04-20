# Ollama LLM Web Application Deployment on AWS 
This Terraform project deploys an Ollama Large Language Model (LLM) on AWS with auto-scaling, a Web UI, and monitoring. The infrastructure includes a VPC, public subnets, security groups, an Application Load Balancer (ALB), auto-scaling groups, and CloudWatch alarms for scaling policies.

## Overview

- **Components**:
  - **Ollama**: [Ollama](https://github.com/ollama/ollama) Deployed as a Docker container on EC2 instances managed by an auto-scaling group.
  - **Web UI**: A [Next.js web interface](https://github.com/jakobhoeg/nextjs-ollama-llm-ui) deployed as a Docker container on EC2 to interact with the Ollama API.
  - **Load Balancer**: Distributes traffic to Ollama instances.
  - **Monitoring**: CloudWatch alarms trigger scaling based on CPU utilization.
- **Architecure Diagram**:
![ollama-llm-diagram](ollama-llm-diagram.png)

## Prerequisites

1. **AWS Account**: With IAM credentials configured for Terraform.
2. **Terraform**: Installed locally (v1.0+ recommended).
3. **AWS CLI**: Configured with `aws configure`.
4. **SSH Key Pair**: Created in AWS for EC2 access (if needed).

## Files Structure
```
├── balancer.tf # ALB, target groups, and listener rules
├── compute.tf # Launch templates, EC2 instances, and ASG
├── monitoring.tf # CloudWatch alarms and scaling policies
├── network.tf # VPC, subnets, and security groups
├── outputs.tf # Terraform outputs (ALB DNS, VPC ID, etc.)
├── variables.tf # Configurable variables
├── main.tf # AWS provider and locals
├── ollama_deploy.sh # User data script for Ollama instances
├── webui_deploy.sh # User data script for Web UI instance
```

## Usage

### 1. Clone the Repository
```bash
git clone <repo-url>
cd <repo-directory>
```
### 2. Configure Variables (Optional)
Modify variables.tf or create a terraform.tfvars file to override defaults:
```hcl
region                  = "us-east-1"
project_name            = "my-ollama-project"
ollama_model            = "tinyllama"  # Change model here, tinyllama as default
ssh_allowed_ips         = ["0.0.0.0/0"]  # Change to your IP for SSH access
http_allowed_ips        = ["0.0.0.0/0"] 
ollama_instance_type    = "t2.medium" # Change instance type here, t2.medium as default
```

### 3. Initialize and Deploy
```bash
terraform init
terraform plan  # Review changes
terraform apply --auto-approve
```

### 4. Access the Web UI
After deployment:
- Access the Web UI via the EC2 instance's public IP (from webui_instance_public_ip output) at http://<PUBLIC_IP>.
- The ALB DNS name (alb_dns_name output) routes traffic to Ollama instances at http://<DNS>/api.

## Outputs
- alb_dns_name: DNS of the Application Load Balancer.
- vpc_id: ID of the created VPC.
- webui_instance_public_ip: Public IP of the Web UI instance.
- ollama_asg_name: Name of the Ollama auto-scaling group.

## Cleanup
To destroy the infrastructure, run:
```bash
terraform destroy -auto-approve
```



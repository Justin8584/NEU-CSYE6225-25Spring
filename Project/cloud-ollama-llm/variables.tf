variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "project name for resource tags"
  type        = string
  default     = "cloud-ollama-llm"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "subnet_cidrs" {
  description = "subnet_cidrs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "ollama_instance_type" {
  description = "EC2 instance type for ollama"
  type        = string
  default     = "t3.medium"
}

variable "webui_instance_type" {
  description = "EC2 instance type for webui"
  type        = string
  default     = "t3.medium"
}

variable "model_storage_size" {
  description = "EBS storage for model"
  type        = number
  default     = 30 # GB
}

variable "root_volume_size" {
  description = "root volume size"
  type        = number
  default     = 30
}

variable "ollama_min_size" {
  description = "ollama min number of instances for autoscaling group"
  type        = number
  default     = 1
}

variable "ollama_max_size" {
  description = "ollama max number of instances for autoscaling group"
  type        = number
  default     = 5
}

variable "ollama_desired_size" {
  description = "ollama desired number of instances for autoscaling group"
  type        = number
  default     = 1
}

variable "ollama_model" {
  description = "the model used in this project"
  type        = string
  default     = "tinyllama" # Can change to other small models
}

variable "ssh_allowed_ips" {
  description = "Allowed ssh ips"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_allowed_ips" {
  description = "Allowed http ips"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "common_tags" {
  description = "common tags for all resources"
  type        = map(string)
  default = {
    "Name"      = "cloud-ollama-llm"
    "Project"   = "cloud-ollama-llm"
    "Owner"     = "yang-jiang"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

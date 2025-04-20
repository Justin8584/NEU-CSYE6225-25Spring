provider "aws" {
  region = var.region
}

# Local Variables
locals {
  nam_prefix = var.project_name
  region     = var.region
}

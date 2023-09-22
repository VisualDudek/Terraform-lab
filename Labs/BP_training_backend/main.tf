terraform {
  required_version = ">= 1.5.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # --- Task 2 ---
  backend "s3" {
    bucket = "terraform-543107016527-eu-north-1-bucket-08fbbd10"
    dynamodb_table = "Terraform"
    region = "eu-north-1"
    key = "state/terraform.tfstate"
  }
  # --- ----
}


provider "aws" {
  default_tags {
    tags = {
      tf_purpose = "training"
    }
  }
}

# -- Task 1 ---
data "aws_ssm_parameter" "s3_bucket_name" {
  name = "TerraformS3"
}
# --- ----


locals {
  name_prefix = "awsninja12"
}

data "aws_availability_zones" "available" {
  state = "available"   # very useful feature bc will exclude dead az
}

output "list_of_az" {
  value = data.aws_availability_zones.available.names
}

variable "ubuntu_enabled" {
  type    = bool
  default = true
}

module "web_server" {
  source = "./modules/web-server"

  number_of_servers = 1
  image_version     = "v1.2.3"
  name_prefix       = local.name_prefix
  sg_prexif_name    = "SGubuntu"
  distro            = "ubuntu"
  vpc_id            = module.vpc.vpc_id         
  public_subnet_ids = module.vpc.public_subnets

  count = var.ubuntu_enabled == true ? 1 : 0
}

module "web_server_amazon" {
  source = "./modules/web-server"

  number_of_servers = 1
  image_version     = "v1.2.3"
  name_prefix       = local.name_prefix
  sg_prexif_name    = "SGamazon"
  distro            = "amazon"
  vpc_id            = module.vpc.vpc_id         
  public_subnet_ids = module.vpc.public_subnets

  count = 1 # Just to support output "*"
}

# --- Task 7 ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.name_prefix
  cidr = "10.0.0.0/16"

  map_public_ip_on_launch = true

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "web_server_server_ip" {
  value = module.web_server[*].web_server-server_ip
}

output "servers_ip" {
  value = concat(
    module.web_server[*].web_server-server_ip,
    module.web_server_amazon[*].web_server-server_ip
  )
}

output "shuffled_subnets" {
  value = concat(
    module.web_server[*].shuffle_result,
    module.web_server_amazon[*].shuffle_result
  )
}

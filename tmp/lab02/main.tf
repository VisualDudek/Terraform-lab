terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "awsninja12"
    dynamodb_table = "awsninja12"
    region = "eu-west-1"
    key = "state/terraform.tfstate"
  }
}

provider "aws" {
  default_tags {
    tags = {
      purpose = "training"
    }
  }
  ignore_tags {
    keys = ["Creator"]
  }
}

module "web_server" {
  source = "./modules/web-server"

  app_version       = "v1.2.3"
  distro            = "ubuntu"
  number_of_servers = 1
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnets
}

module "web_server_ubuntu" {
  source = "./modules/web-server"

  app_version       = "v1.2.3"
  distro            = "ubuntu"
  number_of_servers = 2
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnets
  name_prefix = "${var.name_prefix}-second-${terraform.workspace}"

  count = var.ubuntu_enable == true ? 1 : 0
}

variable "ubuntu_enable" {
  type = bool
  default = true
}

variable "name_prefix" {
  type    = string
  default = "awsninja12"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.name_prefix
  cidr = "10.0.0.0/16"

  azs                     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets          = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  map_public_ip_on_launch = true

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

output "addreses" {
  value = concat(module.web_server.server_ip, module.web_server_ubuntu[*].server_ip)
}
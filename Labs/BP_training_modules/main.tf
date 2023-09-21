terraform {
  required_version = ">= 1.5.6" # Task 3
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      tf_purpose = "training"
    }
  }
}

locals {
  name_prefix = "awsninja12" # Task 7
}

# --- Task 7a ---
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"   # very useful feature bc will exclude dead az
}

output "list_of_az" {
  # value = data.aws_availability_zones.available[*].names 
  value = data.aws_availability_zones.available.names   # FIX
}

# Task 9: add var
variable "ubuntu_enabled" {
  type    = bool
  default = true
}

# --- Task 4 ---
module "web_server" {
  source = "./modules/web-server"

  number_of_servers = 3
  image_version     = "v1.2.3"
  # name_prefix = "awsninja12" # important for stored images names
  name_prefix       = local.name_prefix # Task 7
  sg_prexif_name    = "SGubuntu"
  distro            = "ubuntu"
  vpc_id            = module.vpc.vpc_id         # Task 7
  public_subnet_ids = module.vpc.public_subnets # Task 7

  count = var.ubuntu_enabled == true ? 1 : 0 # Task 9
}

# --- Task 9 ---
module "web_server_amazon" {
  source = "./modules/web-server"

  number_of_servers = 1
  image_version     = "v1.2.3"
  # name_prefix = "awsninja12" # important for stored images names
  # name_prefix       = local.name_prefix # Task 7  
  # name_prefix       = "$(local.name_prefix)-amazon" # Task 7 and  # FIX double SG NOPE
  name_prefix       = local.name_prefix # Task 7 and  # FIX double SG
  sg_prexif_name    = "SGamazon"
  distro            = "amazon"
  vpc_id            = module.vpc.vpc_id         # Task 7
  public_subnet_ids = module.vpc.public_subnets # Task 7

  count = 1 # Just to support output "*"
}

# --- Task 7 ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.name_prefix
  cidr = "10.0.0.0/16"

  map_public_ip_on_launch = true # Task 7: enable public ip

  # azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  # azs             = data.aws_availability_zones.available[*].names # Task 7a
  # azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"] # Task 10
  azs             = data.aws_availability_zones.available.names # FIX check Tack 7a
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# --- Task 8 ---
output "web_server_server_ip" {
  # value = module.web_server.web_server-server_ip
  value = module.web_server[*].web_server-server_ip # Task 9
}

# --- Task 9 ---
output "servers_ip" {
  value = concat(
    module.web_server[*].web_server-server_ip,
    module.web_server_amazon[*].web_server-server_ip
  )
}

# --- Task 10 ---
output "shuffled_subnets" {
  value = concat(
    module.web_server[*].shuffle_result,
    module.web_server_amazon[*].shuffle_result
  )
}

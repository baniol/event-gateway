# module "event-gateway" {
#   source = "terraform"

#   command_list = ["-dev", "-log-level", "debug"]

#   tags = {
#     Application = "event-gateway"
#   }
# }

# output "config_url" {
#   value = "${module.event-gateway.config_url}"
# }

# output "events_url" {
#   value = "${module.event-gateway.events_url}"
# }

# -------
# Testing etcd

provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

locals {
  subnet_names = "${slice(data.aws_availability_zones.available.names, 0, 3)}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "etcd-test"
  cidr = "10.0.0.0/16"

  # TODO dynamic length
  azs = "${local.subnet_names}"

  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  # single_nat_gateway = true

  # tags = "${merge(var.tags, map("Name", var.eg_vpc_name))}"
}

module "etcd" {
  source  = "./modules/etcd"
  subnets = "${module.vpc.public_subnets}"

  ssh_key = "eg-key"
  vpc_id  = "${module.vpc.vpc_id}"
}

data "aws_availability_zones" "available" {}

locals {
  subnet_names = "${slice(data.aws_availability_zones.available.names, 0, 3)}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.eg_vpc_name}"
  cidr = "10.0.0.0/16"

  # TODO dynamic length
  azs             = "${local.subnet_names}"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = "${merge(var.tags, map("Name", var.eg_vpc_name))}"
}

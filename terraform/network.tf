data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

resource "aws_vpc" "event-gateway" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "private" {
  count             = "${var.private_subnets_count}"
  cidr_block        = "${cidrsubnet(aws_vpc.event-gateway.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.event-gateway.id}"
}

resource "aws_subnet" "public" {
  count                   = "${var.public_subnets_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.event-gateway.cidr_block, 8, var.private_subnets_count + count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.event-gateway.id}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "eg-igw" {
  vpc_id = "${aws_vpc.event-gateway.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.event-gateway.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.eg-igw.id}"
}

resource "aws_eip" "eg-eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.eg-igw"]
}

resource "aws_nat_gateway" "eg-nat" {
  subnet_id     = "${aws_subnet.public.0.id}"
  allocation_id = "${aws_eip.eg-eip.id}"
}

resource "aws_route_table" "private" {
  count  = "${var.private_subnets_count}"
  vpc_id = "${aws_vpc.event-gateway.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.eg-nat.id}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${var.private_subnets_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

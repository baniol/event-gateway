data "aws_ami" "coreos_ami" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}

data "aws_subnet" "private" {
  count = "${var.etcd_count}"
  id    = "${element(var.subnets, count.index)}"
}

resource "aws_instance" "etcd" {
  count = "${var.etcd_count}"

  ami                    = "${data.aws_ami.coreos_ami.id}"
  instance_type          = "${var.etcd_instance_type}"
  subnet_id              = "${element(data.aws_subnet.private.*.id, count.index)}"
  private_ip             = "10.0.${count.index}.10"
  user_data              = "${element(data.template_file.user_data.*.rendered, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.etcd.id}"]

  tags {
    Name = "eg-etcd"
  }
}

data "template_file" "user_data" {
  count    = "${var.etcd_count}"
  template = "${file("${path.module}/userdata.json")}"

  vars {
    PRIVATE_IPV4   = "10.0.${count.index}.10"
    cluster_domain = "${var.cluster_domain}"
    node_count     = "${count.index}"
  }
}

resource "aws_security_group" "etcd" {
  name        = "etcd-sg"
  description = "Ingress for etcd"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = 2379
    to_port   = 2380

    # Etcd nodes much see each other
    cidr_blocks = ["${data.aws_subnet.private.*.cidr_block}"]

    # Requests from the event gateway app
    security_groups = ["${var.app_sg}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

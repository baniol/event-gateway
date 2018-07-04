module "etcd" {
  source = "./modules/etcd"

  cluster_domain     = "${var.cluster_domain}"
  etcd_count         = "${var.private_subnets_count}"
  etcd_instance_type = "${var.etcd_instance_type}"
  vpc_id             = "${aws_vpc.event-gateway.id}"
  subnets            = ["${aws_subnet.private.*.id}"]
  app_sg             = ["${aws_security_group.event-service-sg.id}", "${aws_security_group.config-service-sg.id}"]
}

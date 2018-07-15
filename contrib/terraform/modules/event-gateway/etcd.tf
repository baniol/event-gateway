module "etcd" {
  source           = "../../modules/etcd"
  subnets          = "${module.vpc.private_subnets}"
  bastion_enabled  = "${var.bastion_enabled}"
  bastion_subnet   = "${module.vpc.public_subnets[0]}"
  security_groups  = "${aws_security_group.sg-container-ingress.*.id}"
  ec2_type         = "${var.etcd_instance_type}"
  root_volume_iops = "${var.root_volume_iops}"
  root_volume_iops = "${var.root_volume_iops}"
  root_volume_size = "${var.root_volume_size}"
  root_volume_type = "${var.root_volume_type}"
  ssh_key          = "${var.etcd_ssh_key}"
  vpc_id           = "${module.vpc.vpc_id}"
  tags             = "${var.tags}"
  tls_enabled      = "${var.etcd_tls_enabled}"
  instance_count   = "${var.etcd_instance_count}"
  container_image  = "${var.etcd_image}"
  base_domain      = "${var.etcd_base_domain}"
}

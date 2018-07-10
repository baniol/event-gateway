module "etcd" {
  source          = "../../modules/etcd"
  subnets         = "${module.vpc.private_subnets}"
  bastion_enabled = "${var.bastion_enabled}"
  bastion_subnet  = "${module.vpc.public_subnets[0]}"
  security_groups = "${aws_security_group.sg-container-ingress.*.id}"

  ssh_key = "eg-key"
  vpc_id  = "${module.vpc.vpc_id}"
}

module "etcd" {
  source = "github.com/coreos/tectonic-installer//modules/aws/etcd?ref=0a22c73d39f67ba4bb99106a9e72322a47179736"

  base_domain = "${var.base_domain}"

  # TODO necessary ?
  cluster_id              = "tectonic-etcd"
  cluster_name            = "${var.cluster_name}"
  container_image         = "${var.container_image}"
  container_linux_channel = "${var.container_linux_channel}"
  container_linux_version = "${module.container_linux.version}"
  ec2_type                = "${var.ec2_type}"

  #   etcd_iam_role           = "${var.tectonic_aws_etcd_iam_role_name}"
  external_endpoints = []
  extra_tags         = {}

  # ign_etcd_crt_id_list = "${module.ignition_masters.etcd_crt_id_list}"
  ign_etcd_crt_id_list = "${local.etcd_crt_id_list}"

  # output "etcd_dropin_id_list" {
  #   value = "${data.ignition_systemd_unit.etcd.*.id}"
  # }
  #   ign_etcd_dropin_id_list    = "${module.ignition_masters.etcd_dropin_id_list}"
  ign_etcd_dropin_id_list = "${data.ignition_systemd_unit.etcd.*.id}"

  # ign_ntp_dropin_id = "${length(var.tectonic_ntp_servers) > 0 ? module.ignition_masters.ntp_dropin_id : ""}"


  #   ign_profile_env_id         = "${module.ignition_masters.profile_env_id}"
  #   ign_systemd_default_env_id = "${module.ignition_masters.systemd_default_env_id}"

  #   instance_count             = "${length(data.template_file.etcd_hostname_list.*.id)}"
  instance_count   = "${var.instance_count}"
  root_volume_iops = "${var.root_volume_iops}"
  root_volume_size = "${var.root_volume_size}"
  root_volume_type = "${var.root_volume_type}"
  s3_bucket        = "${var.event-gateway-state}"
  # sg_ids                     = "${concat(var.tectonic_aws_etcd_extra_sg_ids, list(module.vpc.etcd_sg_id))}"
  sg_ids      = "${aws_security_group.etcd.*.id}"
  ssh_key     = "${var.ssh_key}"
  subnets     = "${var.subnets}"
  tls_enabled = "${var.tls_enabled}"
}

module "container_linux" {
  source = "github.com/coreos/tectonic-installer//modules/container_linux?ref=0a22c73d39f67ba4bb99106a9e72322a47179736"

  release_channel = "stable"
  release_version = "latest"
}

resource "aws_security_group" "etcd" {
  name   = "eg-etcd"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = "2379"
    to_port   = "2380"
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

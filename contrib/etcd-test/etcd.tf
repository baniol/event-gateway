provider "aws" {
  region = "us-east-1"
}

module "etcd" {
  source = "github.com/coreos/tectonic-installer//modules/aws/etcd?ref=0a22c73d39f67ba4bb99106a9e72322a47179736"

  base_domain             = "${var.base_domain}"
  cluster_id              = "tectonic-etcd"
  cluster_name            = "${var.cluster_name}"
  container_image         = "${var.container_image}"
  container_linux_channel = "stable"
  container_linux_version = "${module.container_linux.version}"
  ec2_type                = "t2.micro"

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
  instance_count   = "3"
  root_volume_iops = "100"
  root_volume_size = "30"
  root_volume_type = "gp2"
  s3_bucket        = "event-gateway-state"
  # sg_ids                     = "${concat(var.tectonic_aws_etcd_extra_sg_ids, list(module.vpc.etcd_sg_id))}"
  sg_ids      = ["sg-05e98379"]
  ssh_key     = "eg-key"
  subnets     = ["subnet-68bdc50d", "subnet-55cf9f78"]
  tls_enabled = "false"
}

module "container_linux" {
  source = "github.com/coreos/tectonic-installer//modules/container_linux?ref=0a22c73d39f67ba4bb99106a9e72322a47179736"

  release_channel = "stable"
  release_version = "latest"
}

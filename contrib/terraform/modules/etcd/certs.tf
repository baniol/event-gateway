locals {
  etcd_crt_id_list = [
    "${data.ignition_file.etcd_ca.*.id}",
    "${data.ignition_file.etcd_client_key.*.id}",
    "${data.ignition_file.etcd_client_crt.*.id}",
    "${data.ignition_file.etcd_server_key.*.id}",
    "${data.ignition_file.etcd_server_crt.*.id}",
    "${data.ignition_file.etcd_peer_key.*.id}",
    "${data.ignition_file.etcd_peer_crt.*.id}",
  ]
}

variable "etcd_count" {
  default = 3
}

data "ignition_file" "etcd_ca_cert_pem" {
  filesystem = "root"
  path       = "/etc/ssl/certs/etcd_ca.pem"
  mode       = 0444
  uid        = 0
  gid        = 0

  content {
    #   The etcd kube CA certificate in PEM format.
    content = "${module.etcd_certs.etcd_ca_crt_pem}"
  }
}

data "ignition_file" "etcd_client_key" {
  path       = "/etc/ssl/etcd/client.key"
  mode       = 0400
  uid        = 0
  gid        = 0
  filesystem = "root"

  content {
    content = "${module.etcd_certs.etcd_client_key_pem}"
  }
}

data "ignition_file" "etcd_client_crt" {
  path       = "/etc/ssl/etcd/client.crt"
  mode       = 0400
  uid        = 0
  gid        = 0
  filesystem = "root"

  content {
    content = "${module.etcd_certs.etcd_client_crt_pem}"
  }
}

data "ignition_file" "etcd_server_key" {
  count = "${var.etcd_count > 0 ? 1 : 0}"

  path       = "/etc/ssl/etcd/server.key"
  mode       = 0400
  uid        = 232
  gid        = 232
  filesystem = "root"

  content {
    content = "${module.etcd_certs.etcd_server_key_pem}"
  }
}

data "ignition_file" "etcd_server_crt" {
  count = "${var.etcd_count > 0 ? 1 : 0}"

  path       = "/etc/ssl/etcd/server.crt"
  mode       = 0400
  uid        = 232
  gid        = 232
  filesystem = "root"

  content {
    content = "${module.etcd_certs.etcd_server_crt_pem}"
  }
}

data "ignition_file" "etcd_peer_key" {
  count = "${var.etcd_count > 0 ? 1 : 0}"

  path       = "/etc/ssl/etcd/peer.key"
  mode       = 0400
  uid        = 232
  gid        = 232
  filesystem = "root"

  content {
    content = "${module.etcd_certs.etcd_peer_key_pem}"
  }
}

data "ignition_file" "etcd_peer_crt" {
  count = "${var.etcd_count > 0 ? 1 : 0}"

  path       = "/etc/ssl/etcd/peer.crt"
  mode       = 0400
  uid        = 232
  gid        = 232
  filesystem = "root"

  content {
    # This var is taken from module.etcd_certs.etcd_peer_crt_pem !!!!
    content = "${module.etcd_certs.etcd_peer_crt_pem}"
  }
}

# -----

module "etcd_certs" {
  # source = "./modules/tls/etcd/signed"
  source = "github.com/coreos/tectonic-installer//modules/tls/etcd/signed?ref=0a22c73d39f67ba4bb99106a9e72322a47179736"

  etcd_ca_cert_path     = "/dev/null"
  etcd_cert_dns_names   = "${data.template_file.etcd_hostname_list.*.rendered}"
  etcd_client_cert_path = "/dev/null"
  etcd_client_key_path  = "/dev/null"

  #   self_signed           = "${var.tectonic_self_hosted_etcd != "" ? "true" : length(compact(var.tectonic_etcd_servers)) == 0 ? "true" : "false"}"
  self_signed = "true"

  #   service_cidr          = "${var.tectonic_service_cidr}"
  service_cidr = "10.3.0.0/16"
}

# data "template_file" "etcd_hostname_list" {
#   count = 3


#   template = "${var.cluster_name}-etcd-${count.index}.${var.base_domain}"


# }


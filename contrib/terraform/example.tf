# TODO provider in modules ? read the docs

provider "aws" {
  region = "us-east-1"
}

module "event-gateway" {
  source = "./modules/event-gateway"

  # bastion_enabled = true
  # tls_enabled     = true
  # ssh_key      = "eg-key"
  command_list = ["-db-hosts", "event-gateway-etcd-0.etcd:2379,event-gateway-etcd-1.etcd:2379,event-gateway-etcd-2.etcd:2379", "-log-level", "debug"]

  tags = {
    Application = "event-gateway"
  }
}

output "config_url" {
  value = "${module.event-gateway.config_url}"
}

output "events_url" {
  value = "${module.event-gateway.events_url}"
}

output "bastion_id" {
  value = "${module.event-gateway.bastion_ip}"
}

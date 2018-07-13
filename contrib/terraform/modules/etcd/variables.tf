variable "cluster_name" {
  default = "event-gateway"
}

variable "security_groups" {
  description = ""
  type        = "list"
}

variable "vpc_id" {
  description = ""
}

variable "base_domain" {
  default = "etcd"
}

variable "instance_count" {
  default = 3
}

variable "ssh_key" {
  description = "SSH key name for access to etcd instance"
}

variable "subnets" {
  description = "Subnets for hosting etcd instances"
  type        = "list"
}

variable "container_linux_channel" {
  default = "stable"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ign_ntp_dropin_id" {
  default = ""
}

variable "tls_enabled" {
  default = false
}

# TODO ? not used ?
variable "etcd_tls_enabledtls_enabled" {
  default = false
}

#TODO to params
variable "container_image" {
  default = "quay.io/coreos/etcd:v3.1.8"
}

variable "use_metadata" {
  default = false
}

variable "root_volume_iops" {}

variable "root_volume_size" {}

variable "root_volume_type" {}

variable "event-gateway-state" {
  default = "event-gateway-state"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "bastion_enabled" {
  default = false
}

variable "bastion_subnet" {
  description = "..."
  default     = 0
}

variable "bastion_name" {
  default = "eg-etcd-bastion"
}

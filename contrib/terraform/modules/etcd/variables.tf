variable "cluster_name" {
  default = "event-gateway"
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

variable "etcd_tls_enabledtls_enabled" {
  default = false
}

variable "container_image" {
  default = "quay.io/coreos/etcd:v3.1.8"
}

variable "use_metadata" {
  default = false
}

variable "root_volume_iops" {
  default = "100"
}

variable "root_volume_size" {
  default = "30"
}

variable "root_volume_type" {
  default = "gp2"
}

variable "event-gateway-state" {
  default = "event-gateway-state"
}

variable "tags" {
  type    = "map"
  default = {}
}

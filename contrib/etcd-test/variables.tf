variable "cluster_name" {
  default = "event-gateway"
}

variable "base_domain" {
  default = "etcd"
}

variable "instance_count" {
  default = 3
}

variable "ign_ntp_dropin_id" {
  default = ""
}

variable "tls_enabled" {
  default = false
}

variable "container_image" {
  default = "quay.io/coreos/etcd:v3.1.8"
}

variable "use_metadata" {
  default = false
}

variable "etcd_tls_enabledtls_enabled" {
  default = false
}

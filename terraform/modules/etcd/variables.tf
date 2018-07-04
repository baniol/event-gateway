variable "cluster_domain" {
  default = "etcd-cluster"
}

variable "etcd_count" {
  description = "Number of nodes in ETCD cluster"
  default     = 3
}

variable "etcd_instance_type" {
  description = "etcd EC2 instance type"
  default     = "t2.micro"
}

variable "subnets" {
  type = "list"
}

variable "vpc_id" {}

variable "app_sg" {
  type = "list"
}

#TODO - remove?
variable "aws_region" {
  default = "us-east-1"
}

variable "command_list" {
  description = "List of parameters for the `event-gateway` command"
  type        = "list"
  default     = ["-log-level", "debug"]
}

variable "eg_image" {
  description = "Event Gateway docker image"
  default     = "serverless/event-gateway:latest"
}

variable "events_port" {
  description = "Event Gateway Events API port number"
  default     = 4000
}

variable "config_port" {
  description = "Port number of the Event Gateway Config API"
  default     = 4001
}

variable "task_count" {
  description = "Number of Event Gateway Fargate tasks"
  default     = 3
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units"
  default     = 256
}

variable "fargate_memory" {
  description = "Fargate instance memory"
  default     = 512
}

variable "cluster_domain" {
  description = "Private domain for etcd discovery"
  default     = "etcd-cluster"
}

variable "etcd_instance_type" {
  description = "etcd nodes type"
  default     = "t2.micro"
}

variable "tags" {
  description = "Additional tags"
  type        = "map"
  default     = {}
}

variable "events_alb_name" {
  description = "Events ALB name"
  default     = "alb-events"
}

variable "config_alb_name" {
  description = "Config ALB name"
  default     = "alb-config"
}

variable "eg_vpc_name" {
  description = "Event Gateway VPC name"
  default     = "eg-vpc"
}

variable "bastion_enabled" {
  description = "Set to true enables SSH access to etcd nodes in the private subnet"
  default     = false
}

variable "root_volume_iops" {
  description = "xxx"
  default     = "100"
}

variable "root_volume_size" {
  description = ""
  default     = "30"
}

variable "root_volume_type" {
  description = ""
  default     = "gp2"
}

variable "ssh_key" {
  description = ""
  default     = ""
}

variable "tls_enabled" {
  description = ""
  default     = false
}

variable "etcd_instance_count" {
  description = ""
  default     = 3
}

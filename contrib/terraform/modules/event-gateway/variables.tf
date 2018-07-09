#TODO - remove?
variable "aws_region" {
  description = "AWS region to the stack"
  default     = "us-east-1"
}

variable "command_list" {
  type    = "list"
  default = ["-log-level", "debug"]
}

variable "public_subnets_count" {
  description = "Number of public subnets"
  default     = 2
}

variable "private_subnets_count" {
  description = "Number of private subnets"
  default     = 3
}

variable "eg_image" {
  description = "Event gateway docker image"
  default     = "serverless/event-gateway:latest"
}

variable "events_port" {
  description = "Port number of the Event Gateway Events API"
  default     = 4000
}

variable "config_port" {
  description = "Port number of the Event Gateway Config API"
  default     = 4001
}

variable "app_count" {
  description = "Number of Event Gateway docker containers"
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
  type    = "map"
  default = {}
}

variable "events_alb_name" {
  description = ""
  default     = "alb-events"
}

variable "config_alb_name" {
  description = ""
  default     = "alb-config"
}

variable "eg_vpc_name" {
  description = ""
  default     = "eg-vpc"
}

variable "vpc_id" {
}

variable "app_name" {
}

variable "environment" {
}

variable "project" {}

variable "instance_type" {
}

variable "instance_subnet_ids" {
  type = "list"
}
variable "sg_app_id"{}
variable "sg_elb_id"{}

variable "elb_subnet_ids" {
  type = "list"
}

variable "max_size" {}

variable "min_size" {}

variable "ssh_key" {}

variable "healthcheck" {
  default = "TCP:80"
}

variable "monitoring_type" {}

variable "service_role" {}

variable "instance_public_ip" {
  description = "Does your instances need an public ip"
  default = "false"
}

variable "solution_stack_name" {
  description = "Name of the stack solution"
  default = "64bit Amazon Linux 2016.03 v2.1.0 running Docker 1.9.1"
}

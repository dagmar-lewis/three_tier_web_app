variable "project_name" {
  description = "Name of the project"
  type = string
}

variable "ami" {
  description = "Launch template ami"
  type = string
}

variable "instance_type" {
  description = "Launch template instance type"
  type = string
}

variable "desired_capacity" {
  description = "Auto scaling group desired capacity"
  type = number
}

variable "max_size" {
  description = "Auto scaling group max size"
  type = number
}

variable "min_size" {
  description = "Auto scaling group min size"
  type = number
}

variable "public_subnets_ids" {
description = "List of public subnets"
type = list(string)
}

variable "private_subnets_ids" {
  description = "List of private subnets"
type = list(string)
}

variable "vpc_id" {
  description = "Main vpc id"
  type = string
}


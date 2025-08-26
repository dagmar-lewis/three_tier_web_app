variable "project_name" {
  description = "Name of the project"
  type = string
}

variable "db_subnets_ids" {
  description = "List of private subnets"
type = list(string)
}

variable "azs" {
  description = "A list of availability zones to deploy subnets in"
  type        = list(string)
}

variable "vpc_id" {
  description = "value"
  type = string
}

variable "private_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_security_group_id" {
  description = "value"
  type = string
}




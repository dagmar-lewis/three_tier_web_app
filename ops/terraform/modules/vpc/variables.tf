variable "region" {
  description = "Default region for provider"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type = string
}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
}

variable "public_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}

variable "db_private_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}


variable "azs" {
  description = "A list of availability zones to deploy subnets in"
  type        = list(string)
}

variable "env" {
  description = "ENV"
  type        = string
}



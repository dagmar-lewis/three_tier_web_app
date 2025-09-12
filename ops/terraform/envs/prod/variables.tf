variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "three-tier-web-app"
}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_private_subnets_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}


variable "azs" {
  description = "A list of availability zones to deploy subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}



variable "ami" {
  description = "Launch template ami"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "Launch template instance type"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "Auto scaling group desired capacity"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Auto scaling group max size"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Auto scaling group min size"
  type        = number
  default     = 2
}



variable "env" {
  description = "Default ENV"
  type        = string
  default     = "prod"
}

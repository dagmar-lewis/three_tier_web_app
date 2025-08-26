output "vpc_id" {
  description = "VPC id."
  value = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "A list of IDS for the public subnets"
  value = [module.vpc.public_subnets_ids]
}

output "private_subnets_ids" {
  description = "A list of IDS for the private subnets"
  value = [module.vpc.private_subnets_ids]
}

output "db_private_subnets_ids" {
  description = "A list of IDS for the private subnets"
  value = [module.vpc.db_private_subnets_ids]
}


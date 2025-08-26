module "vpc" {
  source                   = "../../modules/vpc"
  project_name             = var.project_name
  region                   = var.region
  vpc_cidr                 = var.vpc_cidr
  private_subnets_cidrs    = var.private_subnets_cidrs
  public_subnets_cidrs     = var.public_subnets_cidrs
  db_private_subnets_cidrs = var.db_private_subnets_cidrs
  azs                      = var.azs

}

module "asg" {
  source              = "../../modules/auto_scaling_group"
  project_name        = var.project_name
  instance_type       = var.instance_type
  ami                 = var.ami
  public_subnets_ids  = module.vpc.public_subnets_ids
  private_subnets_ids = module.vpc.private_subnets_ids
  vpc_id              = module.vpc.vpc_id
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

}

module "rds" {
  source                = "../../modules/rds"
  project_name          = var.project_name
  db_subnets_ids        = module.vpc.db_private_subnets_ids
  azs                   = var.azs
  private_subnets_cidrs = var.private_subnets_cidrs
  vpc_id                = module.vpc.vpc_id
  private_security_group_id = module.asg.private_security_group_id
}

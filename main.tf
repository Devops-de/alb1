module "vpc" {
  source    = "./modules/vpc"
  vpc_name  = "my-vpc"
  vpc_cidr  = var.vpc_cidr_block
}

module "networking" {
  source              = "./modules/networking"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidrs = var.public_subnet_cidr_block
  azs                 = var.azs
}

module "alb" {
  source             = "./modules/alb"
  alb_name           = "my-app-alb"
  target_group_name  = "my-app-tg"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.networking.public_subnets
  alb_sg_id          = module.networking.alb_sg_id
}

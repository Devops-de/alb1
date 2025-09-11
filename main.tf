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
  source         = "./modules/alb"
  alb_name       = "my-app-alb"
  alb_internal   = false
  alb_type       = "application"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg_id      = module.networking.alb_sg_id

  target_groups = [
    {
      name                 = "my-app-tg"
      port                 = 80
      protocol             = "HTTP"
      health_check_path     = "/"
      health_check_protocol = "HTTP"
      health_check_port     = "traffic-port"
      health_check_interval = 30
      health_check_timeout  = 5
      healthy_threshold     = 5
      unhealthy_threshold   = 2
      health_check_matcher  = "200"
    }
    # Add more target groups here if needed
  ]

  http_listeners = [
    {
      port              = 80
      protocol          = "HTTP"
      action_type       = "forward"
      target_group_name = "my-app-tg"
    }
    # Add more HTTP listeners here based on your requirements
  ]

  https_listeners = [
    {
      port              = 443
      protocol          = "HTTPS"
      ssl_policy        = "ELBSecurityPolicy-2016-08"
      certificate_arn   = var.acm_cert_arn
      action_type       = "forward"
      target_group_name = "my-app-tg"
    }
    # Add more HTTPS listeners based on your requirements
  ]
}

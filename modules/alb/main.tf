resource "aws_lb" "app_alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.alb_type
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "app_tg" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = each.value.health_check_path
    protocol            = each.value.health_check_protocol
    port                = each.value.health_check_port
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    matcher             = each.value.health_check_matcher
  }
}

resource "aws_lb_listener" "http" {
  for_each = { for l in var.http_listeners : l.port => l }

  load_balancer_arn = aws_lb.app_alb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = each.value.action_type
    target_group_arn = aws_lb_target_group.app_tg[each.value.target_group_name].arn
  }
}

resource "aws_lb_listener" "https" {
  for_each = { for l in var.https_listeners : l.port => l }

  load_balancer_arn = aws_lb.app_alb.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.certificate_arn

  default_action {
    type             = each.value.action_type
    target_group_arn = aws_lb_target_group.app_tg[each.value.target_group_name].arn
  }
}

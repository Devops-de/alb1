output "alb_arn" {
  value = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "target_group_arns" {
  value = { for k, v in aws_lb_target_group.app_tg : k => v.arn }
}

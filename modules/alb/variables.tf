variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "alb_internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "alb_type" {
  description = "Type of the load balancer (application or network)"
  type        = string
  default     = "application"
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_groups" {
  description = "List of target group objects"
  type = list(object({
    name                 = string
    port                 = number
    protocol             = string
    health_check_path     = string
    health_check_protocol = string
    health_check_port     = string
    health_check_interval = number
    health_check_timeout  = number
    healthy_threshold     = number
    unhealthy_threshold   = number
    health_check_matcher  = string
  }))
}

variable "http_listeners" {
  description = "List of HTTP listener objects"
  type = list(object({
    port               = number
    protocol           = string
    action_type        = string
    target_group_name  = string
  }))
  default = []
}

variable "https_listeners" {
  description = "List of HTTPS listener objects"
  type = list(object({
    port               = number
    protocol           = string
    ssl_policy         = string
    certificate_arn    = string
    action_type        = string
    target_group_name  = string
  }))
  default = []
}

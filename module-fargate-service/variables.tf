
variable "ecs_cluster" {}

variable "service_name" {}

# The tag mutability setting for the repository (defaults to IMMUTABLE)
variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "The tag mutability setting for the repository (defaults to IMMUTABLE)"
}

variable "vpc_id" {}

variable "security_groups" {
  default = []
}

variable "region" {}

variable "tags" {}

# === Load Balancer ===

# The loadbalancer subnets
variable "subnet_ids" {}

variable "lb_port" {
  default = "80"
}

variable "lb_protocol" {
  default = "HTTP"
}


# Whether the application is available on the public internet,
# also will determine which subnets will be used (public or private)
variable "internal" {
  default = true
}

# The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused
variable "deregistration_delay" {
  default = "30"
}

# The path to the health check for the load balancer to know if the container(s) are ready
variable "health_check" {
}

variable "health_check_enabled" {
  default = true
}

# How often to check the liveliness of the container
variable "health_check_interval" {
  default = "30"
}

# How long to wait for the response on the health check path
variable "health_check_timeout" {
  default = "10"
}

variable "health_check_grace_period_seconds" {
  default = "1"
}

# What HTTP response code to listen for
variable "health_check_matcher" {
  default = "200-499"
}

variable "lb_access_logs_expiration_days" {
  default = "3"
}



# === Container ===



# The port the container will listen on, used for load balancer health check
# Best practice is that this value is higher than 1024 so the container processes
# isn't running at root.


# The name of the container to run
variable "container_name" {
}

# Container port listening
variable "container_port" {}

variable "launch_type" {
}

# The minimum number of containers that should be running.
# Must be at least 1.
# used by both autoscale-perf.tf and autoscale.time.tf
# For production, consider using at least "2".
variable "ecs_autoscale_min_instances" {
  default = "1"
}

# The maximum number of containers that should be running.
# used by both autoscale-perf.tf and autoscale.time.tf
variable "ecs_autoscale_max_instances" {
  default = "8"
}

# The default docker image to deploy with the infrastructure.
# Note that you can use the fargate CLI for application concerns
# like deploying actual application images and environment variables
# on top of the infrastructure provisioned by this template
# https://github.com/turnerlabs/fargate
# note that the source for the turner default backend image is here:
# https://github.com/turnerlabs/turner-defaultbackend
variable "default_backend_image" {
  default = "quay.io/turner/turner-defaultbackend:0.2.0"
}

variable "task_cpu" {
  default = "256"
}

variable "task_memory" {
  default = "512"
}

# == for EFS ==
variable "volumes" {
  default = []
}

variable "mountPoints" {
  default = []
}

# == Cloudwatch ==


variable "logs_retention_in_days" {
  type        = number
  default     = 90
  description = "Specifies the number of days you want to retain log events"
}

variable "alb_arn" { }

variable "listener_rule_path_pattern" {
  default = []
}

variable "listener_rule_http_header_value" {
  default = []
}

variable "listener_arn" {}

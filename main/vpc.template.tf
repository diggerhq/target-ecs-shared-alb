# this config allows creating subbnets in an existing VPC
data "aws_vpc" "vpc" {
  id = "{{environment_config.vpc_id}}"
}

locals {
  vpc_id = data.aws_vpc.vpc.id
}

# output the vpc ids
output "vpc_id" {
  value = local.vpc_id
}

output "security_group_ids" {
  value = concat([module.fargate-service.security_group_id], var.security_groups)
}
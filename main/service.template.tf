
module "monitoring" {
  count = var.monitoring_enabled ? 1 : 0
  source = "./monitoring"
  ecs_cluster_name = aws_ecs_cluster.app.name
  ecs_service_name = "{{aws_app_identifier}}"
  alarms_sns_topic_arn = var.alarms_sns_topic_arn
  tags = var.tags
}

module "fargate-service" {
  source = "../module-fargate-service"

  ecs_cluster = aws_ecs_cluster.app
  service_name = "{{aws_app_identifier}}"
  region = var.region
  vpc_id = local.vpc_id
  security_groups = var.security_groups
  subnet_ids = var.private_subnets
  alb_arn = "{{ environment_config.alb_arn }}"
  listener_rule_path_pattern = "{{ environment_config.listener_rule_path_pattern }}"
  listener_arn = "{{ environment_config.listener_arn }}"

  {%- if internal is defined %}
  internal={{ internal }}
  {%- endif %}

  health_check = "{{health_check}}"

  {% if environment_config.health_check_disabled %}
  health_check_enabled = false
  {% endif %}

  {% if environment_config.health_check_grace_period_seconds %}
  health_check_grace_period_seconds = "{{environment_config.health_check_grace_period_seconds}}"
  {% endif %}

  {% if environment_config.lb_protocol %}
  lb_protocol = "{{environment_config.lb_protocol}}"
  {% endif %}

  {% if health_check_matcher %}
  health_check_matcher = "{{health_check_matcher}}"
  {% endif %}

  {% if environment_config.ecs_autoscale_min_instances %}
    ecs_autoscale_min_instances = "{{environment_config.ecs_autoscale_min_instances}}"
  {% endif %}

  {% if environment_config.ecs_autoscale_max_instances %}
    ecs_autoscale_max_instances = "{{environment_config.ecs_autoscale_max_instances}}"
  {% endif %}

  container_port = "{{container_port}}"
  container_name = "{{aws_app_identifier}}"
  launch_type = "{{launch_type}}"

  default_backend_image = "quay.io/turner/turner-defaultbackend:0.2.0"
  tags = var.tags

  {% if environment_config.lb_ssl_certificate_arn %}
    lb_ssl_certificate_arn = "{{environment_config.lb_ssl_certificate_arn}}"
  {% endif %}

  # for *.dggr.app listeners
  {% if environment_config.dggr_acm_certificate_arn %}
    dggr_acm_certificate_arn = "{{environment_config.dggr_acm_certificate_arn}}"
  {% endif %}

  {% if task_cpu %}task_cpu = "{{task_cpu}}" {% endif %}
  {% if task_memory %}task_memory = "{{task_memory}}" {% endif %}
}


{% if environment_config.create_dns_record %}
  resource "aws_route53_record" "{{aws_app_identifier}}_r53" {
    zone_id = "{{environment_config.dns_zone_id}}"
    name    = "{{aws_app_identifier}}.{{environment_config.hostname}}"
    type    = "A"

    alias {
      name                   = module.fargate-service.lb_dns
      zone_id                = module.fargate-service.lb_zone_id
      evaluate_target_health = false
    }
  }

  output "{{aws_app_identifier}}_custom_domain" {
      value = aws_route53_record.{{aws_app_identifier}}_r53.fqdn
  }
{% endif %}

output "{{aws_app_identifier}}_docker_registry" {
  value = module.fargate-service.docker_registry
}

output "{{aws_app_identifier}}_lb_dns" {
  value = module.fargate-service.lb_dns
}

output "{{aws_app_identifier}}_lb_arn" {
  value = module.fargate-service.lb_arn
}

output "{{aws_app_identifier}}" {
  value = ""
}


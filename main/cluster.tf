

resource "aws_ecs_cluster" "app" {
  name = var.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.app.name
}
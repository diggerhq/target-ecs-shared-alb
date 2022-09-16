
resource "aws_security_group" "ecs_sg" {
  name        = "${var.ecs_cluster.name}-${var.service_name}-task"
  description = "Limit connections from internal resources while allowing ${var.ecs_cluster.name}-task to connect to all external resources"
  vpc_id      = var.vpc_id
  tags = var.tags
}

resource "aws_security_group_rule" "ecs_egress_rule" {
  description = "Allows egress connections from ecs service"
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "ecs_ingress_rule" {
  description = "Allows ingress connections to ecs service"
  type        = "ingress"
  from_port   = var.container_port
  to_port     = var.container_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs_sg.id
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}
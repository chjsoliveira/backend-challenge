# Criando o Load Balancer - ALB
resource "aws_lb" "authcloud_lb" {
  name               = "authcloud-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]  # Subnets para o Load Balancer

  enable_deletion_protection = false

  tags = {
    Name = "authcloud-load-balancer"
  }
  depends_on = [aws_security_group.lb_security_group]
}

resource "aws_lb_target_group" "authcloud_tg" {
  name        = "authcloud-target-group"
  port        = 30001                      # Porta NodePort configurada no EKS
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"                 # Aponta para as instâncias dos nós do cluster

  health_check {
    path                = "/health"        # Defina o caminho correto do health check
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "authcloud-target-group"
  }
}


# Listener para redirecionar da porta 80 do ALB para a porta 8080 no Target Group
resource "aws_lb_listener" "authcloud_listener80" {
  load_balancer_arn = aws_lb.authcloud_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.authcloud_tg.arn
  }
}

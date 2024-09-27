# Load Balancer para expor o serviço
resource "aws_lb" "auth_cloud_lb" {
  name               = "authcloud-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_security_group.id]
  subnets            = [aws_subnet.public_subnet.id]

  tags = {
    Name = "authcloud-lb"
  }
}

# Target Group para o LB
resource "aws_lb_target_group" "auth_cloud_tg" {
  name     = "authcloud-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.main_vpc

  health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener para o LB
resource "aws_lb_listener" "auth_cloud_listener" {
  load_balancer_arn = aws_lb.auth_cloud_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_cloud_tg.arn
  }
}

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

# Criando o Target Group
resource "aws_lb_target_group" "authcloud_tg" {
  name     = "authcloud-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.main_vpc

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "authcloud-target-group"
  }
}

# Criando o Listener
resource "aws_lb_listener" "authcloud_listener" {
  load_balancer_arn = aws_lb.authcloud_lb.arn
  port              = 30001
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.authcloud_tg.arn}"
  }
  depends_on = [
    aws_lb.authcloud_lb,                  # Listener depende do Load Balancer
    aws_lb_target_group.authcloud_tg       # Listener depende do Target Group
  ]
}

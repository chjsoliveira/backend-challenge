# Criando o Load Balancer
resource "aws_lb" "authcloud_lb" {
  name               = "authcloud-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks_security_group.id]
  subnets            = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]  # Subnets para o Load Balancer

  enable_deletion_protection = false

  tags = {
    Name = "authcloud-load-balancer"
  }
}

# Criando o Target Group
resource "aws_lb_target_group" "authcloud_tg" {
  name     = "authcloud-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.main_vpc

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 5
    unhealthy_threshold = 2
    port                = "80"
    protocol            = "HTTP"
  }

  tags = {
    Name = "authcloud-target-group"
  }
}

# Criando o Listener
resource "aws_lb_listener" "authcloud_listener" {
  load_balancer_arn = aws_lb.authcloud_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        target_group_arn = aws_lb_target_group.authcloud_tg.arn
        weight           = 1
      }
    }
  }
}

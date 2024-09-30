resource "aws_security_group" "lb_security_group" {
  name        = "lb-security-group"
  description = "Allow traffic for Load Balancer"
  vpc_id      = var.main_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb-security-group"
  }
}


resource "aws_security_group" "eks_security_group" {
  name        = "eks-security-group"
  description = "Allow traffic for EKS nodes"
  vpc_id      = var.main_vpc

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Ajuste de acordo com sua CIDR de VPC
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_security_group.id]  # Permitir tráfego do Load Balancer
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_security_group.id]  # Permitir tráfego do Load Balancer
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
}

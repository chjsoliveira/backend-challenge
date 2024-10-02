resource "aws_security_group" "lb_security_group" {
  name   = "lb-security-group"
  vpc_id = var.main_vpc

  # Ingress: Permitir tráfego HTTP/HTTPS de 0.0.0.0/0
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Aberto ao público
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Aberto ao público
  }

  # Egress: Permitir tráfego para os nós do cluster na porta 30001
  egress {
    from_port                = 30001
    to_port                  = 30001
    protocol                 = "tcp"
    destination_security_group_id = aws_security_group.eks_security_group.id  # Security Group dos nós do cluster
  }

  tags = {
    Name = "lb-security-group"
  }
}


resource "aws_security_group" "eks_security_group" {
  name   = "eks-security-group"
  vpc_id = var.main_vpc

  # Ingress: Permitir tráfego na porta 30001 vindo do Load Balancer
  ingress {
    from_port                = 30001
    to_port                  = 30001
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.lb_security_group.id  # Security Group do Load Balancer
  }

  # Egress: Permitir todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"         # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
  
}


# Security Group para EKS
resource "aws_security_group" "eks_security_group" {
  name        = "eks-security-group"
  description = "Allow traffic from API Gateway and Load Balancer"
  vpc_id      = var.main_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso público (ajuste conforme necessário)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permitir todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"
  }

  tags = {
    Name = "eks-security-group"
  }
}

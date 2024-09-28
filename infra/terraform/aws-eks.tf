# Criando o Cluster EKS
resource "aws_eks_cluster" "auth_cloud_cluster" {
  name     = "authcloud-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.public_subnets
  }

  depends_on = [aws_iam_role_policy_attachment.eks_role_policy]
}

# Criando o IAM Role para o EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "eks-role"
  }
}

# Anexando políticas ao IAM Role do EKS
resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Criando um Fargate Profile para o EKS
resource "aws_eks_fargate_profile" "auth_cloud_fargate_profile" {
  cluster_name = aws_eks_cluster.auth_cloud_cluster.name
  fargate_profile_name = "authcloud-fargate-profile"

  pod_execution_role_arn = aws_iam_role.eks_role.arn

  selector {
    namespace = "default"  # O namespace onde seus pods estarão
  }
}

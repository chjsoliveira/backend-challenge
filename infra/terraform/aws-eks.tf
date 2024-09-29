# Criando o Cluster EKS
resource "aws_eks_cluster" "auth_cloud_cluster" {
  name     = "authcloud-cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_1a.id,
      aws_subnet.private_subnet_1b.id,
    ]
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
    }, {
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }, {
        Action = [
          "eks:*",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "iam:PassRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
        ],
        Effect = "Allow",
        Resource = "*"
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

# Anexando política de execução de pods Fargate
resource "aws_iam_role_policy_attachment" "fargate_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_role.name
}

# Criando um Fargate Profile para o EKS
resource "aws_eks_fargate_profile" "auth_cloud_fargate_profile" {
  cluster_name           = aws_eks_cluster.auth_cloud_cluster.name
  fargate_profile_name   = "authcloud-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_role.arn

  selector {
    namespace = "default"  # O namespace onde seus pods estarão
  }

  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id
  ]
}

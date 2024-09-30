# Criando o Cluster EKS
resource "aws_eks_cluster" "auth_cloud_cluster" {
  name     = "authcloud-cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.32"

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
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-role"
  }
}
# Criando o IAM Role para os Nodes do EKS
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}
# Criando uma política IAM para o EKS
resource "aws_iam_policy" "eks_custom_policy" {
  name        = "EKSCustomPolicy"
  description = "Custom policy for EKS with necessary permissions."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

# Anexando a política personalizada ao IAM Role do EKS
resource "aws_iam_role_policy_attachment" "eks_custom_policy_attachment" {
  policy_arn = aws_iam_policy.eks_custom_policy.arn
  role       = aws_iam_role.eks_role.name
}

# Anexando políticas ao IAM Role do EKS
resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Anexando políticas ao IAM Role dos Nodes do EKS
resource "aws_iam_role_policy_attachment" "eks_node_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

# Criar node group 
resource "aws_eks_node_group" "auth_cloud_node_group" {
  cluster_name    = aws_eks_cluster.auth_cloud_cluster.name
  node_group_name = "authcloud-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id,
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_type = "t4g.nano"
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

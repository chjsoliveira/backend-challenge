# Criando o Cluster EKS
resource "aws_eks_cluster" "auth_cloud_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.31"

  vpc_config {

    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = [
      aws_subnet.private_subnet_1a.id,
      aws_subnet.private_subnet_1b.id,
      aws_subnet.public_subnet_1a.id
    ]
    security_group_ids = [aws_security_group.eks_security_group.id]
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
      },
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
    Name = "eks-role"
  }
}

# IAM Role para Nodes (Node Group)
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "eks-node-role"
  }
}

# Anexando políticas ao IAM Role dos Nodes do EKS
resource "aws_iam_role_policy_attachment" "eks_node_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
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
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

    ami_type       = "AL2_x86_64"  # AMI Amazon Linux 2 para x86_64
  instance_types = ["t3.medium"]  # Substitua pelo tipo de instância que deseja usar
  capacity_type  = "ON_DEMAND"    # Tipo de capacidade (On-Demand, Spot)
  disk_size      = 20             # Tamanho do disco em GB

  tags = {
    "Name"                               = "authcloud-node-group"
    "kubernetes.io/cluster/authcloud-cluster" = "owned"
  }
}


# IAM Role para as instâncias do Node Group
resource "aws_iam_instance_profile" "eks_instance_profile" {
  name = "eks-instance-profile"
  role = aws_iam_role.eks_node_role.name
}

# Criando um Fargate Profile para o EKS
resource "aws_eks_fargate_profile" "auth_cloud_fargate_profile" {
  cluster_name           = aws_eks_cluster.auth_cloud_cluster.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.eks_role.arn

  selector {
    namespace = "kube-system" 
  }

  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id
  ]
  depends_on = [aws_eks_cluster.auth_cloud_cluster]
}

resource "aws_iam_openid_connect_provider" "default" {
  url             = aws_eks_cluster.auth_cloud_cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

# Obter as instâncias do NodeGroup EKS
data "aws_autoscaling_group" "eks_autosg" {
  # O filtro aqui deve corresponder às tags ou propriedades do seu NodeGroup
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [aws_eks_node_group.authcloud-node-group.node_group_name]
  }
}

# Registro das instâncias do NodeGroup no Target Group do ALB
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count            = length(data.aws_autoscaling_group.eks_autosg.instances)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = data.aws_autoscaling_group.eks_autosg.instances[count.index].id
  port             = 30001  # Porta NodePort no Kubernetes
}

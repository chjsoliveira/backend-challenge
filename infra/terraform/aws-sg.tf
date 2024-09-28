# Security Group para ECS Fargate
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  description = "Allow HTTP traffic"
  vpc_id      = var.main_vpc

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "ecs-security-group"
  }
}

# IAM Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECR Repository
resource "aws_ecr_repository" "auth_cloud_repo" {
  name                 = "authcloud"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "authcloud-repo"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "auth_cloud_cluster" {
  name = "authcloud-cluster"

  tags = {
    Name = "authcloud-cluster"
  }
}

# Task Definition
resource "aws_ecs_task_definition" "auth_cloud_task" {
  family                   = "authcloud-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "authcloud"
    image     = "${aws_ecr_repository.auth_cloud_repo.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      # Remover hostPort
    }]
  }])

  tags = {
    Name = "authcloud-task"
  }
}

# ECS Service
resource "aws_ecs_service" "auth_cloud_service" {
  name            = "authcloud-service"
  cluster         = aws_ecs_cluster.auth_cloud_cluster.id
  task_definition = aws_ecs_task_definition.auth_cloud_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.auth_cloud_tg.arn
    container_name   = "authcloud"
    container_port   = 80
  }

  tags = {
    Name = "authcloud-service"
  }
}

# Load Balancer
resource "aws_lb" "auth_cloud_lb" {
  name               = "authcloud-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_security_group.id]
  subnets            = var.public_subnets

  tags = {
    Name = "authcloud-lb"
  }
}

# Target Group
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

# Listener
resource "aws_lb_listener" "auth_cloud_listener" {
  load_balancer_arn = aws_lb.auth_cloud_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_cloud_tg.arn
  }
}

# Security Group para EKS
resource "aws_security_group" "eks_security_group" {
  name        = "eks-security-group"
  description = "Allow traffic from API Gateway and Load Balancer"
  vpc_id      = var.main_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]  # Permitir tráfego do Load Balancer
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

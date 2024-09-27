# Criando o ECS Cluster
resource "aws_ecs_cluster" "auth_cloud_cluster" {
  name = "authcloud-cluster"

  tags = {
    Name = "authcloud-cluster"
  }
}

# Criando uma Task Definition para rodar o container Docker
resource "aws_ecs_task_definition" "auth_cloud_task" {
  family                   = "authcloud-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "authcloud"
      image     = "${aws_ecr_repository.auth_cloud_repo.repository_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }]
    }
  ])

  tags = {
    Name = "authcloud-task"
  }
}

# Service ECS para rodar a task
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

resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name      = "notification-api"
    image     = "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${aws_ecr_repository.notification_service_repo.name}:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_service" "notification_api_service" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.notification_service.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]  # Replace with your subnet IDs
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
}

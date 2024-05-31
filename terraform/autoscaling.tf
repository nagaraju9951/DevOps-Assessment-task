resource "aws_application_autoscaling_target" "notification_api_scaling_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.notification_service.name}/${aws_ecs_service.notification_api_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_application_autoscaling_policy" "notification_api_scaling_policy" {
  name               = "notification-api-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_application_autoscaling_target.notification_api_scaling_target.resource_id
  scalable_dimension = aws_application_autoscaling_target.notification_api_scaling_target.scalable_dimension
  service_namespace  = aws_application_autoscaling_target.notification_api_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

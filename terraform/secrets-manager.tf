resource "aws_secretsmanager_secret" "notification_service_secret" {
  name = "notification_service_secret"
}

resource "aws_secretsmanager_secret_version" "notification_service_secret_version" {
  secret_id     = aws_secretsmanager_secret.notification_service_secret.id
  secret_string = jsonencode({
    DATABASE_PASSWORD = "your-db-password"
    API_KEY           = "your-api-key"
  })
}

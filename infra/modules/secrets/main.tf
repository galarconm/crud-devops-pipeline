resource "aws_secretsmanager_secret" "db" {

  name                    = "${var.project_name}/${var.environment}/db-secret"
  recovery_window_in_days = 0 # 0 means the secrete can be deleted immediately.connection {
  tags = {
    Name = "${var.project_name}-${var.environment}-db-secret"
  }

}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = var.db_host
    name     = var.db_name
    port     = 5432
    dbname   = var.db_name
  })

}
resource "aws_ssm_parameter" "medici_database_password" {
  name  = "database_password"
  type  = "SecureString"
  value = var.database_master_password
}

resource "aws_ssm_parameter" "medici_database_username" {
  name  = "database_username"
  type  = "SecureString"
  value = var.database_master_password
}


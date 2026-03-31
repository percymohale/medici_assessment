resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "main-db-subnet-group"
  subnet_ids  = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
  description = "Private subnets for RDS"

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "medici_rds_instance" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "medici-health-db"
  db_name                = "medicidb"
  username               = "medici_admin"
  password               = aws_ssm_parameter.medici_database_password.value
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}
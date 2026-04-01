######################################
######## RDS SECURITY GROUPS ########
#####################################

resource "aws_security_group" "rds_security_group" {
  name        = "medici_rds_sg"
  description = "Allow inbound traffic only for MYSQL and all outbound traffic"
  vpc_id      = aws_vpc.medici_network.id

   ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.medici_web_server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group_${var.environment}"
  }
}


######################################
######## EC2 SECURITY GROUPS ########
#####################################

resource "aws_security_group" "medici_web_server_sg" {
  name        = "medici_webserver_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.medici_network.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict in production
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
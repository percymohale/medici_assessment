######################################
######## RDS SECURITY GROUPS ########
#####################################

resource "aws_security_group" "rds_security_group" {
  name        = "medici_rds_sg"
  description = "Allow inbound traffic only for MYSQL and all outbound traffic"
  vpc_id      = aws_vpc.medici_network.id
  tags = {
    Name = "rds_security_group_${var.environment}"
  }
}

resource "aws_vpc_security_group_egress_rule" "rds_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "rds_allow_http_ipv4" {
  security_group_id = aws_security_group.medici_web_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
  
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
}
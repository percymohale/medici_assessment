resource "aws_instance" "medici_webserver" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.web_server_instance_profile.name
  subnet_id                   = aws_subnet.public_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.medici_web_server_sg.id]
  user_data_replace_on_change = true
  key_name                    = aws_key_pair.deployer_keypair.key_name
  user_data                   = <<-EOF
            #!/bin/bash
            sudo dnf update -y
            sudo dnf install nginx -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            sudo yum update -y
            sudo dnf install -y docker
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -a -G docker ec2-user
            sudo chmod 666 /var/run/docker.sock

            EOF
  tags = {
    Name = "Medici_WebServer_${var.environment}"
  }
}

resource "aws_key_pair" "deployer_keypair" {
  key_name   = "private_key_file"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "public_ip" {
  value = aws_instance.medici_webserver.public_ip
}
# Provider
provider "aws" {
  region = "us-east-1"
}
###
# Resoruces
###

# Security groups
resource "aws_security_group" "web-server-tf-sg" {
  name        = "web-server-tf-sg"
  description = "Security group allowing  SSH and HTTP Access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  tags = {
    Name        = "web-server-tf-sg"
    Environment = "Prod"
    Owner       = "quemirassapo@gmail.com"
    Team        = "Development"
    Project     = "exercise-1"
  }
}

# Pair keys
resource "aws_key_pair" "web-server-tf-ssh" {
  key_name   = "web-server-tf-ssh"
  public_key = file("./web-server-tf.key.pub")

  tags = {
    Name        = "web-server-tf-ssh"
    Environment = "Prod"
    Owner       = "quemirassapo@gmail.com"
    Team        = "Development"
    Project     = "exercise-1"
  }
}

# EC2 Instance
resource "aws_instance" "web-server-tf" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t3.micro"

  user_data = <<-EOF
  #!/bin/bash
  sudo yum install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx
  EOF

  key_name = aws_key_pair.web-server-tf-ssh.key_name

  vpc_security_group_ids = [
    aws_security_group.web-server-tf-sg.id
  ]

  tags = {
    Name        = "web-server-tf"
    Environment = "Prod"
    Owner       = "quemirassapo@gmail.com"
    Team        = "Development"
    Project     = "exercise-1"
  }
}

output "server-public-ip" {
  description = "IP Publica de la instancia EC2"
  value       = aws_instance.web-server-tf.public_ip
}

output "server-public-dns" {
  description = "DNS ppublico de la isntancia EC2"
  value       = aws_instance.web-server-tf.public_dns
}

output "server-private-ip" {
  description = "IP Privada de la instancia EC2"
  value       = aws_instance.web-server-tf.private_ip
}

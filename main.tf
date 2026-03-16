provider "aws" {
  region = "us-east-2"
}
 
# Security Group
resource "aws_security_group" "web_sg" {
  name = "terraform-web-sg"
 
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
}
 
# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0b0b78dcacbab728f"
  instance_type = "t3.micro"
 
  security_groups = [aws_security_group.web_sg.name]
 
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Siddanagouda Cloud Engineer</h1><p>Welcome to the website</p>" > /var/www/html/index.html
              EOF
 
  tags = {
    Name = "Terraform-WebServer"
  }
}
 
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
 
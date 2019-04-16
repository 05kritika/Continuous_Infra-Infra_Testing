# DEMO.TF



## PROVIDERS ##

provider "aws" {
  
  region     = "us-east-1"
}


## RESOURCES ##

# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name        = "nginx_sg"
 

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "nginx-security-group"
  }

}


resource "aws_instance" "nginx" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"

  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

   tags {
    Name = "nginx"
  }

   provisioner "local-exec" {
    command = "echo ${aws_instance.nginx.public_ip} > ip_address.txt"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #     "sudo apt-get install nginx -y",
  #     "sudo systemctl start nginx"
  #   ]
  #}
}


resource "aws_vpc" "testing" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
}



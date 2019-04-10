## VARIABLES.TF

variable "private_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION

  default ="/home/ubuntu/kritika.pem"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "kritika"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

# Ubuntu Precise 18.04 LTS (x64)
variable "aws_amis" {
  description = "ubuntu 18.04 AMI"
  default = "ami-0a313d6098716f372"
}


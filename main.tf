# main.tf — my first Terraform config: one Ubuntu server on AWS.
# `terraform apply` builds everything below; `terraform destroy` removes it.

# 1. Which cloud + region we're working in (Sydney).
provider "aws" {
  region = "ap-southeast-2"
}

# 2. A firewall (security group) that allows SSH in.
#    cidr_blocks 0.0.0.0/0 = open to the whole internet — fine for a
#    throwaway lab; in the real world you'd lock this to your own IP.
resource "aws_security_group" "lab" {
  name        = "tf-lab-ssh"
  description = "SSH access for terraform lab"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all outbound allowed
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. The server itself: one small Ubuntu 24.04 box, reusing the SSH
#    key you already created earlier (lab-key).
resource "aws_instance" "lab" {
  ami                    = "ami-020728ad6199d7fa0" # Ubuntu 24.04, ap-southeast-2
  instance_type          = "t3.micro"
  key_name               = "lab-key"
  vpc_security_group_ids = [aws_security_group.lab.id]

  tags = {
    Name = "tf-lab-box"
  }
}

# 4. After it builds, print the server's public IP so you can SSH in.
output "public_ip" {
  value = aws_instance.lab.public_ip
}

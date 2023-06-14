terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Default values for AWS resources(Tags, location etc.)  
provider "aws" {
  region  = "us-east-1"
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "GroupB-Team(another-pavels)"
      Project     = "GroupB-Recipes"
      Name = "GroupB-Team"
    }
  }
}

# Amazon Virtual Private Cloud (VPC) definition
resource "aws_vpc" "GroupB_Recipes_vpc" {
##  cidr_block = "10.0.0.0/16"
}

# Subnet definition in VPC
resource "aws_subnet" "GroupB_Recipes_web_subnet" {
  vpc_id     = aws_vpc.GroupB_Recipes_vpc.id
  cidr_block = "10.0.0.0/24"
}

# Internet Gateway attached to VPC
resource "aws_internet_gateway" "GroupB_Recipes_igw" {
  vpc_id = aws_vpc.GroupB_Recipes_vpc.id
}

# Default Route for VPC
resource "aws_default_route_table" "GroupB_Recipes_route_table" {
  default_route_table_id = aws_vpc.GroupB_Recipes_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GroupB_Recipes_igw.id
  }
}

# Security group (firewall filter)
resource "aws_security_group" "GroupB_Recipes_secgroup_web" { 
  description = "GroupB-Recipes Security Group" 
  vpc_id = aws_vpc.GroupB_Recipes_vpc.id 

# Incoming non-default ssh (2234)
  ingress {
    from_port   = 2234
    to_port     = 2234
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Incoming http port
  ingress { 
    from_port   = 80 
    to_port     = 80 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
# Incoming https port 
  ingress { 
    from_port   = 443 
    to_port     = 443 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
# Incoming ping 
  ingress { 
    from_port   = -1 
    to_port     = -1 
    protocol    = "icmp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
# Outgoing "allow all" 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ec2 instance definition 
resource "aws_instance" "GroupB_Recipes_WEB" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.GroupB_Recipes_web_subnet.id
  associate_public_ip_address = true
  key_name  = "pavelsJG-amazon-key"
  user_data = "${file("cloud-init.sh")}"
  vpc_security_group_ids = [ 
  aws_security_group.GroupB_Recipes_secgroup_web.id, 
  ]
  tags = {
  Name = "GroupB-Recipes-EC2"
} 
}

# Prints dynamically assigned public IP. 
output "WEB_instance_public_IP" {
  description = "Public IP of GroupB_Recipes_WEB EC2 instance"
  value       = aws_instance.GroupB_Recipes_WEB.public_ip
}

# Prints dynamically assigned DNS name (if any)
output "WEB_instance_public_DNS" {
  description = "Public IP of GroupB_Recipes_WEB EC2 instance"
  value       = aws_instance.GroupB_Recipes_WEB.public_dns
}

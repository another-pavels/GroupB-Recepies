terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "GroupB-Team(another-pavels)"
      Project     = "GroupB-Recepies"
      Name = "GroupB-Team"
    }
  }
}

resource "aws_vpc" "GroupB_Recepies_vpc" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "GroupB_Recepies_web_subnet" {
  vpc_id     = aws_vpc.GroupB_Recepies_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "GroupB_Recepies_igw" {
  vpc_id = aws_vpc.GroupB_Recepies_vpc.id
}

resource "aws_default_route_table" "GroupB_Recepies_route_table" {
  default_route_table_id = aws_vpc.GroupB_Recepies_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GroupB_Recepies_igw.id
  }
}

resource "aws_security_group" "GroupB_Recepies_secgroup_web" { 
  description = "Pavels M WEB Security Group" 
  vpc_id = aws_vpc.GroupB_Recepies_vpc.id 
  ingress {
    from_port   = 2234
    to_port     = 2234
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { 
    from_port   = 80 
    to_port     = 80 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  } 
  ingress { 
    from_port   = 443 
    to_port     = 443 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  } 
  ingress { 
    from_port   = -1 
    to_port     = -1 
    protocol    = "icmp" 
    cidr_blocks = ["0.0.0.0/0"] 
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "GroupB_Recepies_WEB" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.GroupB_Recepies_web_subnet.id
  associate_public_ip_address = true
  key_name  = "pavelsJG-amazon-key"
  user_data = "${file("cloud-init.sh")}"
  vpc_security_group_ids = [ 
  aws_security_group.GroupB_Recepies_secgroup_web.id, 
  ]
  tags = {
  Name = "GroupB-Recepies-EC2"
} 
}

output "WEB_instance_public_IP" {
  description = "Public IP of GroupB_Recepies_WEB EC2 instance"
  value       = aws_instance.GroupB_Recepies_WEB.public_ip
}

output "WEB_instance_public_DNS" {
  description = "Public IP of GroupB_Recepies_WEB EC2 instance"
  value       = aws_instance.GroupB_Recepies_WEB.public_dns
}

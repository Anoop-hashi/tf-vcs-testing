terraform {
  cloud {
    hostname     = "app.staging.terraform.io"
    organization = "tf-ai-ecosystem"

    workspaces {
      name = "anoop-test"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 (Amazon Linux 2023)"
  type        = string
  default     = "ami-0c101f26f147fa7fd" # Amazon Linux 2023 in us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

data "aws_ami" "hc-base-ubuntu-2404" {
  for_each = toset(["amd64", "arm64"])

  filter {
    name   = "name"
    values = [format("hc-base-ubuntu-2404-%s-*", each.value)]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  most_recent = true
  owners      = ["888995627335"] # ami-prod account
}


resource "aws_instance" "example" {
  ami           = data.aws_ami.hc-base-ubuntu-2404["amd64"].id
  instance_type = var.instance_type
  tags = {
    Name = "Terraform-CLI-Example"
  }
}

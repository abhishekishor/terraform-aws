terraform {
  required_providers {
    aws = {
        
        source = "hashicorp/aws"
        version = "~>4.16"

    }
  }

  required_version = ">= 1.2.0"

}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "testing" {
  ami           = "ami-0607784b46cbe5816"
  instance_type = "t3.micro"

  tags = {

    Name = "mera-ec2"

  }
}

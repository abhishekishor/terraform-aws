terraform {
  required_providers {
    aws = {

      source  = "hashicorp/aws"
      version = "~>4.16"

    }
  }

  required_version = ">= 1.2.0"



  backend "s3" {
    bucket         = "terra-remote-st"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "remote-state"
  }
}
provider "aws" {
  region = "ap-south-1"
}


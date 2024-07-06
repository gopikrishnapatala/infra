terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
        

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.nano"

  tags = {
    Name = "terraform_inst"
  }
}

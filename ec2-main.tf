terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
{
        AWS_ACCESS_KEY_ID = "credentials('AKIAU6GDWU5PLYI7XUW3')"        
	AWS_SECRET_ACCESS_KEY = "credentials('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')"
    }
provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform_inst"
  }
}

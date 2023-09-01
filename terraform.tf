terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11.0"
    }
  }
  backend "s3" {
    bucket = "terraform-tfstate-personal"
    key    = "prueba-albo/terraform.tfstate"
    region = "us-east-1"
  }
}


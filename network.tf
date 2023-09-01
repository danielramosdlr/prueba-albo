module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-vpc"
  cidr = "172.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["172.0.1.0/24", "172.0.2.0/24"]
  public_subnets  = ["172.0.101.0/24", "172.0.102.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw             = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    project = var.project
  }
}
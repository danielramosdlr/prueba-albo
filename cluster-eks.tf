module "eks" {
  source     = "terraform-aws-modules/eks/aws"
  version    = "~> 19.0"
  depends_on = [module.vpc]

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    master-node = {
      min_size       = 1
      max_size       = 1
      desire_size    = 1
      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
    }

    nodes-group = {
      min_size       = 2
      max_size       = 2
      desired_size   = 2
      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
    }
  }

  manage_aws_auth_configmap = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    project = var.project
  }
}

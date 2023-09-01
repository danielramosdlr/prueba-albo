module "eks" {
  source     = "terraform-aws-modules/eks/aws"
  version    = "~> 19.0"
  depends_on = [module.vpc]

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.21"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    master-node = {
      name           = "master-node"
      min_size       = 1
      max_size       = 1
      desire_size    = 1
      instance_types = ["t2.micro"]
    }

    group-nodes = {
      name           = "group-nodes"
      min_size       = 2
      max_size       = 2
      desired_size   = 2
      instance_types = ["t2.micro"]
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

  create_iam_role          = true
  iam_role_name            = "${var.project}-eks-rol"
  iam_role_use_name_prefix = false
  iam_role_additional_policies = {
    CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    project = var.project
  }
}

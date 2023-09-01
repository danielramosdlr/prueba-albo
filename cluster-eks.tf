module "eks" {
  source     = "terraform-aws-modules/eks/aws"
  version    = "~> 19.0"
  depends_on = [module.vpc]

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.21"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    nodes-group = {
      min_capacity     = 1
      max_capacity     = 3
      desired_capacity = 3
      instance_types   = ["t2.micro"]
      capacity_type    = "ON_DEMAND"
    }
  }

  cluster_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    project = var.project
  }
}

#resource "aws_iam_role_policy_attachment" "attach-cloudwatchagent-policy" {
#  role       = var.iam_node_rol
#  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#}

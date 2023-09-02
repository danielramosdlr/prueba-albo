module "eks" {
  source     = "terraform-aws-modules/eks/aws"
  version    = "~> 19.0"
  depends_on = [module.vpc]

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.23"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::361656941569:user/dti-cli",
      username = "dti-cli",
      groups = [
        "system:master"
      ]
    }
  ]
  aws_auth_roles = [
    {
      rolearn = "arn:aws:iam::361656941569:role/DTi.Admin",
      groups = [
        "system:master"
      ]
    }
  ]

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

  eks_managed_node_groups = {
    master = {
      min_capacity             = 1
      max_capacity             = 1
      desired_capacity         = 1
      instance_types           = ["t3.micro"]
      capacity_type            = "ON_DEMAND"
      create_iam_role          = true
      iam_role_name            = "${var.project}-eks-master-rol"
      iam_role_use_name_prefix = false
      iam_role_additional_policies = {
        CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        AmazonEKS_CNI_Policy        = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }
    }
#    nodes = {
#      min_capacity             = 2
#      max_capacity             = 2
#      desired_capacity         = 2
#      instance_types           = ["t3.micro"]
#      capacity_type            = "ON_DEMAND"
#      create_iam_role          = true
#      iam_role_name            = "${var.project}-eks-nodes-rol"
#      iam_role_use_name_prefix = false
#      iam_role_additional_policies = {
#        CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#        AmazonEKS_CNI_Policy        = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#      }
#    }
  }
}
module "eks" {
  source     = "terraform-aws-modules/eks/aws"
  version    = "~> 19.0"
  depends_on = [module.vpc]

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  manage_aws_auth_configmap = true
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

  eks_managed_node_group_defaults = {

  }

  eks_managed_node_groups = {
    master = {
      create_iam_role          = true
      iam_role_name            = "${var.project}-eks-rol"
      iam_role_use_name_prefix = false
      iam_role_additional_policies = {
        CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        AmazonEKS_CNI_Policy        = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }

      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = "test"
      }

    }
  }
}

#module "eks_managed_node_group" {
#  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#
#  name            = "${var.project}-eks-node-group"
#  cluster_name    = module.eks.cluster_name
#  cluster_version = "1.27"
#
#  subnet_ids = module.vpc.private_subnets
#
#  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
#  vpc_security_group_ids            = [module.eks.node_security_group_id]
#
#
#  tags = {
#    project = var.project
#  }
#}
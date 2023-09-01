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
    nodes-group = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }

  manage_aws_auth_configmap = true

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

#module "eks_managed_node_group" {
#  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#
#  name            = "${var.project}-eks-mng"
#  cluster_name    = "${var.project}-eks"
#  cluster_version = "1.27"
#
#  subnet_ids = module.vpc.private_subnets
#
#  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
#  vpc_security_group_ids            = [module.eks.node_security_group_id]
#
#  min_size     = 1
#  max_size     = 10
#  desired_size = 1
#
#  instance_types = ["t3.small"]
#  capacity_type  = "ON_DEMAND"
#
#  taints = {
#    dedicated = {
#      key    = "dedicated"
#      value  = "gpuGroup"
#      effect = "NO_SCHEDULE"
#    }
#  }
#
#  tags = {
#    project = var.project
#  }
#}
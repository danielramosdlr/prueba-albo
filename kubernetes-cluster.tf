# resource "aws_iam_role" "eks-iam-role" {
#   name = "${var.project}-eks-iam-role"

#   path = "/"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#   {
#    "Effect": "Allow",
#    "Principal": {
#     "Service": "eks.amazonaws.com"
#    },
#    "Action": "sts:AssumeRole"
#   }
#  ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks-iam-role.name
# }
# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks-iam-role.name
# }

# resource "aws_eks_cluster" "cluster-eks" {
#   name     = "${var.project}-eks"
#   role_arn = aws_iam_role.eks-iam-role.arn

#   vpc_config {
#     subnet_ids = module.vpc.private_subnets
#   }

#   depends_on = [
#     aws_iam_role.eks-iam-role,
#   ]
# }

# resource "aws_iam_role" "node-rol" {
#   name = "${var.project}-eks-node-rol"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node-rol.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node-rol.name
# }

# resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
#   policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
#   role       = aws_iam_role.node-rol.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node-rol.name
# }

# resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#   role       = aws_iam_role.node-rol.name
# }

# resource "aws_eks_node_group" "node-group" {
#   cluster_name    = aws_eks_cluster.cluster-eks.name
#   node_group_name = "${var.project}-node-group"
#   node_role_arn   = aws_iam_role.node-rol.arn
#   subnet_ids      = module.vpc.private_subnets
#   instance_types  = ["t3.micro"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 1
#     min_size     = 1
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy
#   ]
# }

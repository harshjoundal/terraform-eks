locals {
    cluster_name = var.cluster-name
}

resource "random_integer" "random_suffix" {
  min = 1000
  max = 9999
}

resource "aws_iam_role" "eks_cluster_role" {
    count = var.is_eks_role_enabled ? 1 : 0
    name = "${local.cluster_name}-role-${random_integer.random_suffix.result}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Service = "eks.amazonaws.com"
                }
                Action= "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "AmazomEKSClusterPolicy" {
  count = var.is_eks_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster_role[count.index].name
}
resource "aws_iam_role" "eks-nodegroup-role" {
    count = var.is_eks_nodegroup_role_enabled ? 1 : 0
    name = "${local.cluster_name}-nodegroup-role-${random_integer.random_suffix.result}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonWorkerNodePolicy" {
  count = var.is_eks_nodegroup_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-nodegroup-role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
    count = var.is_eks_nodegroup_role_enabled ? 1 : 0
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks-nodegroup-role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
    count      = var.is_eks_nodegroup_role_enabled ? 1 : 0
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.eks-nodegroup-role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEBSCSIDriverPolicy" {
  count      = var.is_eks_nodegroup_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks-nodegroup-role[count.index].name
}

# OIDC

# data "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks-oidc.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:default:aws-test"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks-oidc.arn]
#       type        = "Federated"
#     }
#   }
# }
# resource "aws_iam_role" "eks-oidc" {
#   assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
#   name = "eks-oidc"
# }

# resource "aws_iam_policy" "eks-oidc-policy" {
#     name = "test-policy"
#     policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#         {
#         Action   = [
#             "s3:ListAllMyBuckets",
#             "s3:GetBucketLocation",
#             "*"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#         }
#     ]
# })
  
# }

# resource "aws_iam_role_policy_attachment" "eks-oidc-policy-attach" {
#     role = aws_iam_role.eks-oidc.name
#     policy_arn = aws_iam_policy.eks-oidc-policy.arn
# }

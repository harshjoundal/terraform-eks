

resource "aws_eks_cluster" "eks" {
  count = var.is-eks-cluster-enabled ? 1 : 0
  name = var.cluster-name
  role_arn = var.role-arn
  version = var.cluster-version


  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access = var.endpoint-public-access
    security_group_ids = var.security_group_ids
  }

  access_config {
    authentication_mode = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = var.cluster-name
    Env = var.env
  }
}

# OIDC Provider

resource "aws_iam_openid_connect_provider" "eks-oidc" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-certificate.certificates[0].sha1_fingerprint]
  url = data.tls_certificate.eks-certificate.url
}

# OIDC ROLE

data "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-test"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-oidc.arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role" "eks-oidc" {
  assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
  name = "eks-oidc"
}

resource "aws_iam_policy" "eks-oidc-policy" {
    name = "test-policy"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
        Action   = [
            "s3:ListAllMyBuckets",
            "s3:GetBucketLocation",
            "*"
        ]
        Effect   = "Allow"
        Resource = "*"
        }
    ]
})
  
}

resource "aws_iam_role_policy_attachment" "eks-oidc-policy-attach" {
    role = aws_iam_role.eks-oidc.name
    policy_arn = aws_iam_policy.eks-oidc-policy.arn
}

# AddOns for EKS Cluster
resource "aws_eks_addon" "eks-addons" {
  for_each      = { for idx, addon in var.addons : idx => addon }
  cluster_name = aws_eks_cluster.eks[0].name
  addon_name = each.value.name
  addon_version = each.value.version

  depends_on = [  aws_eks_node_group.ondemand-node,
    aws_eks_node_group.spot_node ]
}

# NodeGroups

resource "aws_eks_node_group" "ondemand-node" {
  cluster_name = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster-name}-on-demand-nodes"
  node_role_arn = var.node_role_arn

  scaling_config {
    desired_size = var.desired_capacity_on_demand
    min_size = var.min_capacity_on_demand
    max_size = var.max_capacity_on_demand
  }

  subnet_ids = var.subnet_ids
  instance_types = var.ondemand_instance_types
  capacity_type = "ON_DEMAND"
  labels = {
    type = "ondemand"
  }
  update_config {
    max_unavailable = 1
  }
  tags = {
    "Name" = "${var.cluster-name}-ondemand-nodes"
  }
  depends_on = [aws_eks_cluster.eks]
}

resource "aws_eks_node_group" "spot_node" {
  cluster_name = var.cluster-name
  node_group_name = "${var.cluster-name}-spot-nodes"
  node_role_arn = var.node_role_arn

  scaling_config {
    desired_size = var.desired_capacity_spot
    min_size     = var.min_capacity_spot
    max_size     = var.max_capacity_spot
  }

  subnet_ids = var.subnet_ids

  instance_types = var.spot_instance_types
  capacity_type = "SPOT"

  update_config {
    max_unavailable = 1
  }
  tags = {
    "Name" = "${var.cluster-name}-spot-nodes"
  }
  
  labels = {
    type      = "spot"
    lifecycle = "spot"
  }

  disk_size = 50

  depends_on = [aws_eks_cluster.eks]
}


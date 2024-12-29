output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role[0].arn
  description = "ARN of the EKS cluster role"
}
output "eks-nodegroup-role-arn" {
  value = aws_iam_role.eks-nodegroup-role[0].arn
}
output "pri-subnet-ids" {
  value = aws_subnet.private-subnet.*.id
  description = "List of private subnet IDs"
}
output "eks-cluster-sg" {
  value = aws_security_group.eks-cluster-sg.id
}
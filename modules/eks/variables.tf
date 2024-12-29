variable "is-eks-cluster-enabled" {}
variable "cluster-name" {}
# variable "cluster-role-arn" {}
variable "role-arn" {}
variable "cluster-version" {}
# variable "pri-subnet-ids" {}
variable "subnet_ids" {}
variable "endpoint-private-access" {}
variable "endpoint-public-access" {}
# variable "eks-cluster-sg" {}
variable "security_group_ids" {}
variable "env" {}
variable "addons" {}
# variable "eks-nodegroup-role-arn" {}
variable "node_role_arn" {}
variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}
variable "ondemand_instance_types" {}
variable "desired_capacity_spot" {}
variable "min_capacity_spot" {}
variable "max_capacity_spot" {}
variable "spot_instance_types" {}

variable "aws-region" {}
variable "env" {}
variable "cluster-name" {}
variable "is_eks_role_enabled" { }
variable "is_eks_nodegroup_role_enabled" {}

variable "lockfile_table_name"{}


variable "vpc-cidr-block" {}
variable "vpc-name" {}
variable "igw-name" {}
variable "pub-subnet-count" {}
variable "pub-cidr-block" {}
variable "pub-availability-zone" {}
variable "pub-sub-name" {}
variable "pri-subnet-count" {}
variable "pri-cidr-block" {}
variable "pri-availability-zone" {}
variable "pri-sub-name" {}
variable "public-rt-name" {}
variable "eip-name" {}
variable "ngw-name" {}
variable "private-rt-name" {}
variable "eks-sg" {}

# eks
variable "is-eks-cluster-enabled" {}
variable "cluster-version" {}
variable "endpoint-private-access" {}
variable "endpoint-public-access" {}
# variable "eks-cluster-sg" {type = list(string)}
# variable "pri-subnet-ids" {type = list(string)}
variable "addons" {}
# variable "eks-nodegroup-role-arn" {}
variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}
variable "ondemand_instance_types" {}
variable "desired_capacity_spot" {}
variable "min_capacity_spot" {}
variable "max_capacity_spot" {}
variable "spot_instance_types" {}
locals {
  env = var.env
  org = "medium"
}

module "iam_roles" {
  source = "../modules/iam"
  cluster-name = var.cluster-name
  is_eks_role_enabled = var.is_eks_role_enabled
  is_eks_nodegroup_role_enabled = var.is_eks_nodegroup_role_enabled
  env = local.env
}

module "vpc" {
  source = "../modules/vpc"
  pri-cidr-block = var.pri-cidr-block
  pri-sub-name = var.pri-sub-name
  eip-name = var.eip-name
  pri-availability-zone = var.pri-availability-zone
  private-rt-name = var.private-rt-name
  public-rt-name = var.public-rt-name
  pub-availability-zone = var.pub-availability-zone
  env = var.env
  cidr_block = var.vpc-cidr-block
  cluster-name = var.cluster-name
  igw-name = var.igw-name
  vpc-name = var.vpc-name
  pub-subnet-count = var.pub-subnet-count
  pri-subnet-count = var.pri-subnet-count
  pub-cidr-block = var.pub-cidr-block
  pub-sub-name = var.pub-sub-name
  ngw-name = var.ngw-name
  eks-sg = var.eks-sg

  depends_on = [ module.iam_roles ]
}

module "eks" {
  source = "../modules/eks"
  cluster-name = var.cluster-name
  role-arn = module.iam_roles.cluster_role_arn
  cluster-version = var.cluster-version
  subnet_ids = module.vpc.pri-subnet-ids
  endpoint-private-access = var.endpoint-private-access
  endpoint-public-access = var.endpoint-public-access
  is-eks-cluster-enabled = var.is-eks-cluster-enabled
  security_group_ids = [module.vpc.eks-cluster-sg]
  env = var.env
  addons = var.addons
  desired_capacity_on_demand = var.desired_capacity_on_demand
  desired_capacity_spot = var.desired_capacity_spot
  max_capacity_on_demand = var.max_capacity_on_demand
  max_capacity_spot = var.max_capacity_spot
  min_capacity_on_demand = var.min_capacity_on_demand
  min_capacity_spot = var.min_capacity_spot
  ondemand_instance_types = var.ondemand_instance_types
  spot_instance_types = var.spot_instance_types
  node_role_arn = module.iam_roles.eks-nodegroup-role-arn

  depends_on = [ module.vpc ]
}
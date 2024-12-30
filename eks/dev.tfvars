aws-region = "ap-south-1a"
env = "dev"
cluster-name = "eks-cluster"
is_eks_role_enabled = true
is_eks_nodegroup_role_enabled = true

lockfile_table_name = "Lock-Files"

vpc-cidr-block = "10.16.0.0/16"
vpc-name = "my-vpc"
igw-name = "igw"
pub-subnet-count = 3
pub-cidr-block = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
pub-availability-zone = ["ap-south-1a","ap-south-1b","ap-south-1a"]
pub-sub-name          = "subnet-public"
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]
pri-availability-zone = ["ap-south-1a","ap-south-1b","ap-south-1a"]
pri-sub-name          = "subnet-private"
public-rt-name        = "public-route-table"
private-rt-name       = "private-route-table"
eip-name              = "elasticip-ngw"
ngw-name              = "ngw"
eks-sg                = "eks-sg"
pri-subnet-count      = 3

# EKS
is-eks-cluster-enabled = true
cluster-version = "1.30"
endpoint-private-access = true
endpoint-public-access = false
ondemand_instance_types = ["t3a.medium"]
spot_instance_types = ["c5a.large"]
desired_capacity_on_demand = "1"
min_capacity_on_demand     = "1"
max_capacity_on_demand     = "5"
desired_capacity_spot      = "1"
min_capacity_spot          = "1"
max_capacity_spot          = "10"

addons = [
  {
    name    = "vpc-cni",
    version = "v1.18.1-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.11.1-eksbuild.9"
  },
  {
    name    = "kube-proxy"
    version = "v1.29.3-eksbuild.2"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.30.0-eksbuild.1"
  }
  # Add more addons as needed
]

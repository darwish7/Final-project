	module "main-vpc" {
  source         = "./vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "main-vpc"
}

module "pub_subnet" {
  source                   = "./pub_subnet"
  vpc-id                   = module.main-vpc.vpc-id
  subnet_cidr_block        = { us-east-1a = "10.0.0.0/24", us-east-1b = "10.0.2.0/24" }
  igw_name                 = "public_igw"
  cidr_block_public_source = "0.0.0.0/0"
}

module "private_subnet" {
  source                   = "./private_subnet"
  vpc-id                   = module.main-vpc.vpc-id
  subnet_cidr_block        = { us-east-1a = "10.0.1.0/24", us-east-1b = "10.0.3.0/24" }
  cidr_block_public_source = "0.0.0.0/0"
  natgw_subnet             = module.pub_subnet.subnet-id[0]
}



module "public-ec2" {
  source          = "./public_ec2"
  vpc_id          = module.main-vpc.vpc-id
  instance_type   = "t2.micro"
  public_ec2_name = "public-ec2"
  subnet_id      = module.pub_subnet.subnet-id[1]
}

module "EKS"{
    source = "./EKS"
    name = "EKS-cluster"
    subnet_id = module.private_subnet.subnet-id

}
module "EKS-NODE"{
    source = "./eks-node"
    subnet_ids = module.private_subnet.subnet-id
    clusterDemo = module.EKS.eks-name 
}

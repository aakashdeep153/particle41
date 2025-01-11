provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = element(data.aws_availability_zones.available.names, 0)

  tags = {
    Name = "${var.name}-public-subnet-1"
    Type = "Public"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = element(data.aws_availability_zones.available.names, 1)

  tags = {
    Name = "${var.name}-public-subnet-2"
    Type = "Public"
  }
}

resource "aws_subnet" "private_subnet_1" {
   vpc_id            = aws_vpc.main.id 
   cidr_block        = var.private_subnet_1_cidr 
   availability_zone = element(data.aws_availability_zones.available.names,0) 

   tags ={ 
      Name="${var.name}-private-subnet-1"
      Type="Private"
   } 
}

resource "aws_subnet" "private_subnet_2" { 
   vpc_id           = aws_vpc.main.id  
   cidr_block       = var.private_subnet_2_cidr  
   availability_zone= element(data.aws_availability_zones.available.names,1) 

   tags={ 
      Name="${var.name}-private-subnet-2"
      Type="Private"
   } 
}

data "aws_availability_zones" "available" {}

module "eks_cluster" {
     source          = "terraform-aws-modules/eks/aws"

     cluster_name    = var.cluster_name  
     cluster_version         ="1.21"

     subnets         =[for subnet in [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id] : subnet]
     vpc_id         = aws_vpc.main.id  

     node_groups={
         eks_nodes={
             desired_capacity=2   
             max_capacity=3     
             min_capacity=1     

             instance_type="m6a.large"

             key_name              ="<your-key-pair-name>" # Optional: specify your EC2 key pair name for SSH access.
         }
     }

     tags={
         Environment="dev"
         ManagedBy="Terraform"
     }
}

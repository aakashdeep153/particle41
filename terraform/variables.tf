variable "region" {
    description ="AWS Region where resources will be created."
    default ="us-west-2"
}

variable "name" {    
    description ="Name prefix for all resources."    
    default ="simpletimeservice-cluster"
}   

variable “vpc_cidr” {    
description=”CIDR block for VPC.”    
default=”10.0.0.0/16”   
}   

variable “public_subnet_1_cidr” {    
description=”CIDR block for public subnet.”    
default=”10.0.1.0/24”   
}   

variable “public_subnet_2_cidr” {    
description=”CIDR block for second public subnet.”    
default=”10.0.2.0/24”   
}   

variable “private_subnet_1_cidr” {     
description=”CIDR block for first private subnet.”     
default=”10.0.3.0/24”   
}    

variable “private_subnet_2_cidr” {     
description=”CIDR block for second private subnet.”     
default=”10.0.4.0/24”
}

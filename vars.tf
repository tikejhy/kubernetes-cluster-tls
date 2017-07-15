########### VPC
variable "vpc_cidr_block" {
    default 	= "10.31.0.0/16"
    description	= "VPC CIDR"
}


variable "public_subnet_cidr_blocks" {
  default 	= {
    zone0 	= "10.31.1.0/24"
    zone1 	= "10.31.2.0/24"
    zone2 	= "10.31.3.0/24"
  count		= "3"
  }
  description 	= "Public Range CIDR within the vpc_cidr"
}

variable "private_subnet_cidr_blocks" {
  default       = {
    zone0       = "10.31.4.0/24"
    zone1       = "10.31.5.0/24"
    zone2       = "10.31.6.0/24"
    count		= "3"
  }
  description   = "Private Range CIDR within the vpc_cidr"
}

variable "vpc_tag" {
  default	= "kube-project"
}

########### Region and Availability
variable "region" {
    default 	= "eu-west-1"
    description = "The Region of AWS where resources are going to be created."
}


variable "availability_zones" {
  default 	= {
    	zone0 	= "eu-west-1a"
    	zone1 	= "eu-west-1b"
    	zone2 	= "eu-west-1c"
  }
  description 	= "The availability zones where resources are going to be created."
}

variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
}

############ Instance
variable "master_instance_var" {
  default       = {
    count       = "1"
    type        = "t2.micro"
    blockSize	= "15"
    ami		= "ami-16776970"
    keyname	= "kube_KEY"
    cycle	= "true"
    nextnode    = "5"
  }
  description   = "Master instance variables"
}


variable "node_instance_var" {
  default       = {
    count       = "1"
    type        = "t2.micro"
    blockSize	= "100"
    ami		= "ami-16776970"
    keyname	= "kube_KEY"
    cycle       = "true"
  }
  description   = "Node instance variables"
}

variable "server_instace_var" {
  default       = {
    count       = "1"
    type        = "t2.micro"
    blockSize	= "100"
    ami		= "ami-16776970"
    keyname	= "kube_KEY"
    cycle       = "true"
  }
  description   = "Node instance variables"
}

variable "etcd_instance_var" {
  default       = {
    count       = "1"
    type        = "t2.micro"
    blockSize   = "15"
    ami         = "ami-16776970"
    keyname     = "kube_KEY"
    cycle       = "true"
    nextnode    = "5"
  }
  description   = "etcd instance variables"
}

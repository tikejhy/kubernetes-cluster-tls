module "nodes" {
  source = "./modules/nodes"

    count       = "0"
    type        = "t2.micro"
    blockSize   = "100"
    ami         = "ami-16776970"
    keyname     = "kube_KEY"
    cycle       = "true"
    server_tag_Name = "NamecommingfromVar"
    server_tag_Role = "RoleCommingFromVar"
    securitygroupid = "sg-ed29fd95"
    subnet_id       = "subnet-61f55906"

}

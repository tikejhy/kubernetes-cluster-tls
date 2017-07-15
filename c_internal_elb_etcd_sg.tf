resource "aws_security_group" "internalelb" {
  name        = "${var.vpc_tag}_internal_elb_etcd_sg"
  description = "Used in the terraform"
  vpc_id = "${aws_vpc.kube_vpc.id}"

    # HTTP access from anywhere
  ingress {
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }
  
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ensure the VPC has an Internet gateway or this step will fail
  depends_on = ["aws_internet_gateway.gw"]
   
}

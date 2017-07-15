resource "aws_security_group" "internalelbapiserver" {
  name        = "${var.vpc_tag}_internal_elb_api_sg"
  description = "Used in the terraform"
  vpc_id = "${aws_vpc.kube_vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
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

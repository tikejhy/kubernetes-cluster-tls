resource "aws_security_group" "kube-default" {
  name        = "kube-${var.vpc_tag}-default"
  description = "Allow all inbound traffic from kube-test attached machine"
  vpc_id      = "${aws_vpc.kube_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["80.169.174.36/32"]
  }
  
  ingress {
    from_port   = 2379
    to_port     = 2379
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }
 
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
   from_port = 0
   to_port   = 0
   protocol    = "-1"
   self        = true

  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

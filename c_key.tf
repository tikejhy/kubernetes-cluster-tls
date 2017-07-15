resource "aws_key_pair" "keypair" {
    key_name = "${var.vpc_tag}_keypair"
    public_key = "${file("${path.module}/keys/id_rsa.pub")}"
}


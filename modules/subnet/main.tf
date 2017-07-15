resource "aws_instance" "server" {
  ami 		= "${var.ami}"
  instance_type = "${var.type}"
  key_name 	= "${var.keyname}"
  subnet_id     = "${var.subnet_id}"

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user = "centos"
    private_key = "${file("${path.module}/keys/kube-key")}"
    agent = false
    bastion_host = ["${aws_instance.kube-bastion.0.public_ip}"]
    bastion_user = "centos"
    bastion_port = 22
    host = "${self.private_ip}"
    private_key = "${file("${path.module}/keys/kube-key")}"
    timeout = "2m"
  }
  
  count         = "${var.count}"
  tags {
    Name        = "${var.server_tag_Name}",
    Role        = "${var.server_tag_Role}"
  }


  root_block_device {
    volume_size = "${var.blockSize}"
	}

   vpc_security_group_ids = ["${var.securitygroupid}"]
}

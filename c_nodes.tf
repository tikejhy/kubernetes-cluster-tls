resource "aws_instance" "kube-node" {
  ami 		= "${var.node_instance_var["ami"]}"
  instance_type = "${var.node_instance_var["type"]}"
  key_name 	= "${var.node_instance_var["keyname"]}"
  subnet_id 	= "${element(aws_subnet.private-subnet.*.id,count.index)}"

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

  provisioner "file" {
    source      = "/home/tikedev/kube-terra/initial/conf/kube-prereq"
    destination = "/tmp/kube-prereq"
  }

  count         = "${var.node_instance_var["count"]}"
  tags {
    Name 	= "kube-node-${count.index + 1}",
    Role        = "kube-node"
  }

  root_block_device {
    volume_size = "${var.node_instance_var["blockSize"]}"
	}

  vpc_security_group_ids = ["${aws_security_group.kube-default.id}"]
 
}

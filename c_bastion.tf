resource "aws_instance" "kube-bastion" {
  ami 		= "${var.master_instance_var["ami"]}"
  instance_type = "${var.master_instance_var["type"]}"
  key_name 	= "${var.master_instance_var["keyname"]}"
  subnet_id 	= "${element(aws_subnet.public-subnet.*.id,count.index)}"

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user = "centos"
    private_key = "${file("${path.module}/keys/kube-key")}"
  }

  provisioner "file" {
    source      = "/home/tikedev/kube-terra/initial/conf/kube-prereq"
    destination = "/tmp/kube-prereq"
  } 
  
  provisioner "file" {
    source	= "/home/tikedev/kube-terra/initial/keys/kube-key"
    destination = "~/.ssh/id_rsa"
  } 
  
  provisioner "remote-exec" {
    inline = [
    	"chmod 600 ~/.ssh/id_rsa"
             ]
}

  count         = 1
  tags {
    Name 	= "bastion",
    Role	= "bastion"
  }

  root_block_device {
   volume_size	= "${var.master_instance_var["blockSize"]}"
  }

  vpc_security_group_ids = ["${aws_security_group.kube-default.id}"]
  
}

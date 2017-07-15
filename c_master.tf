resource "aws_instance" "kube-master" {
  ami 		= "${var.master_instance_var["ami"]}"
  instance_type = "${var.master_instance_var["type"]}"
  key_name 	= "${var.master_instance_var["keyname"]}"
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
  
  provisioner "file" {
    source	= "/home/tikedev/kube-terra/initial/keys/kube-key"
    destination = "~/.ssh/id_rsa"
  } 
  
  provisioner "remote-exec" {
    inline = [
    	"chmod 600 ~/.ssh/id_rsa"
             ]
}

  count         = "${var.master_instance_var["count"]}"
  tags {
    Name 	= "kube-master-${count.index + 1}",
    Role	= "kube-master"
  }

  root_block_device {
   volume_size	= "${var.master_instance_var["blockSize"]}"
  }

  vpc_security_group_ids = ["${aws_security_group.kube-default.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.master_instance_profile.id}"
  
}

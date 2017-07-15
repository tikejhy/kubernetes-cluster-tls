resource "aws_instance" "kube-etcd" {
  ami 		= "${var.etcd_instance_var["ami"]}"
  instance_type = "${var.etcd_instance_var["type"]}"
  key_name 	= "${var.etcd_instance_var["keyname"]}"
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

  count         = "${var.etcd_instance_var["count"]}"
  tags {
    Name 	= "kube-etcd-${count.index + 1}",
    Role	= "kube-etcd"
  }

  root_block_device {
   volume_size	= "${var.etcd_instance_var["blockSize"]}"
  }

  vpc_security_group_ids = ["${aws_security_group.kube-default.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.master_instance_profile.id}"
  
#  provisioner "local-exec" {
#    command = "sleep 120 && cd ./ansible && ansible-playbook --limit tag_Role_kube_etcd master.yml --private-key=~/.ssh/id_rsa_new -u centos"
#  }
}

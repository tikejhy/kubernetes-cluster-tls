data "template_file" "example" {
  template = "${file("${path.module}/sshconfig.tpl")}"
  vars {
    bastionIP = "${aws_instance.kube-bastion.public_ip}"

  }
}

resource "null_resource" "export_rendered_template" {
 provisioner "local-exec" {
    command = "cat <<FILE > ~/.ssh/config \n${data.template_file.example.rendered}\nFILE"
        }
}



data "template_file" "efs-url" {
  template = "${file("${path.module}/efs-task-main.tpl")}"
  vars {
    efs-url = "${aws_efs_file_system.efs.id}"

  }
}

resource "null_resource" "export_rendered_template_efs" {
 provisioner "local-exec" {
    command = "cat <<FILE > .//ansible/roles/efs-client/tasks/main.yml \n${data.template_file.efs-url.rendered}\nFILE"
        }
}

data "template_file" "ansible_ec2_vars_kube_etcd" {
  template = "${file("${path.module}/ansible_ec2_vars_kube_etcd.tpl")}"
  vars {
    ec2_keypair	        = "${var.etcd_instance_var["keyname"]}"
    ec2_security_group 	= "${aws_security_group.kube-default.id}"
    ec2_instance_type 	= "${var.etcd_instance_var["type"]}"
    ec2_image		= "${var.etcd_instance_var["ami"]}"
    ec2_region		= "${var.region}"
    ec2_subnet_ids      = "${aws_subnet.private-subnet.0.id}, ${aws_subnet.private-subnet.1.id}, ${aws_subnet.private-subnet.2.id}"
    ec2_tag_Name	= "kube-etcd-${var.etcd_instance_var["nextnode"]}"
    ec2_tag_Role	= "kube-etcd"
    ec2_tag_State	= "unconfigured"
    ec2_prv_subnet_1    = "${aws_subnet.private-subnet.0.id}"
    ec2_prv_subnet_2    = "${aws_subnet.private-subnet.1.id}"
    ec2_prv_subnet_3    = "${aws_subnet.private-subnet.2.id}"
    vpc_tag             = "${var.vpc_tag}"
  }
}

resource "null_resource" "render_ansible_ec2_vars_kube_etcd" {
 provisioner "local-exec" {
    command = "cat <<FILE > .//ansible/vars/ec2_vars/kube-etcd.yml \n${data.template_file.ansible_ec2_vars_kube_etcd.rendered}\nFILE"
        }
}

data "template_file" "ansible_ec2_vars_kube_master" {
  template = "${file("${path.module}/ansible_ec2_vars_kube_master.tpl")}"
  vars {
    ec2_keypair         = "${var.master_instance_var["keyname"]}"
    ec2_security_group  = "${aws_security_group.kube-default.id}"
    ec2_instance_type   = "${var.master_instance_var["type"]}"
    ec2_image           = "${var.master_instance_var["ami"]}"
    ec2_region          = "${var.region}"
    ec2_subnet_ids      = "${aws_subnet.private-subnet.0.id}, ${aws_subnet.private-subnet.1.id}, ${aws_subnet.private-subnet.2.id}"
    ec2_tag_Name        = "kube-etcd-${var.master_instance_var["nextnode"]}"
    ec2_tag_Role        = "kube-master"
    ec2_tag_State       = "unconfigured"
    ec2_prv_subnet_1	= "${aws_subnet.private-subnet.0.id}"
    ec2_prv_subnet_2	= "${aws_subnet.private-subnet.1.id}"
    ec2_prv_subnet_3	= "${aws_subnet.private-subnet.2.id}"
    vpc_tag		= "${var.vpc_tag}"
  }
}

resource "null_resource" "render_ansible_ec2_vars_kube_master" {
 provisioner "local-exec" {
    command = "cat <<FILE > .//ansible/vars/ec2_vars/kube-master.yml \n${data.template_file.ansible_ec2_vars_kube_master.rendered}\nFILE"
        }
}

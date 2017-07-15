resource "aws_efs_file_system" "efs" {
	creation_token = "${var.vpc_tag}-efs"
	tags {
		Name = "${var.vpc_tag}-efs"
		ManagedBy = "terraform"
	}
}

resource "aws_efs_mount_target" "efs" {
	file_system_id = "${aws_efs_file_system.efs.id}"
	security_groups = ["${aws_security_group.kube-default.id}"] 
        subnet_id = "${element(aws_subnet.private-subnet.*.id,count.index)}"
	count = "${var.private_subnet_cidr_blocks["count"]}"
}

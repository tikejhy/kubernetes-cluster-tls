output "master_instance_ips" {
  value = ["${aws_instance.kube-master.*.private_ip}", "${aws_instance.kube-master.*.private_dns}"]
}

output "node_instace_ips" {
  value = ["${aws_instance.kube-node.*.private_ip}", "${aws_instance.kube-node.*.private_dns}"]
}

output "etcd_instace_ips" {
  value = ["${aws_instance.kube-etcd.*.private_ip}", "${aws_instance.kube-etcd.*.private_dns}"]
}

output "test_this_sht" {
  value = "${(aws_instance.kube-master.kube-instance-1.public_ip)}"
}

output "This is kube-fs id" {
  value = "${aws_efs_file_system.efs.id}"
}


output "This is friki subnet" {
  value = ["${aws_instance.kube-master.*.subnet_id}"]
}

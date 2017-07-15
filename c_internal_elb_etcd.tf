resource "aws_elb" "kubemasterinternalmasterelb" {
  name               = "kube-internal-${var.vpc_tag}-etcd"
  security_groups    = ["${aws_security_group.internalelb.id}"]
  subnets = ["${aws_instance.kube-etcd.*.subnet_id}"]
  internal = true
 
  listener {
    instance_port     = 2379
    instance_protocol = "TCP"
    lb_port           = 2379
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:2379"
    interval            = 5
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.kube-etcd.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags {
    Name = "kube-internal-${var.vpc_tag}-etcd",
    Role = "kube-master-etcd"
  }
}

resource "aws_route53_record" "etcd" {
  zone_id = "${aws_route53_zone.kube_master_route53.zone_id}"
  name    = "etcd.kube-master.ashishnepal.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.kubemasterinternalmasterelb.dns_name}"
    zone_id                = "${aws_elb.kubemasterinternalmasterelb.zone_id}"
	evaluate_target_health = false
  }
}

resource "aws_elb" "kubemasterinternalapielb" {
  name               = "kube-internal-${var.vpc_tag}-api"
  security_groups    = ["${aws_security_group.internalelbapiserver.id}"]
  subnets = ["${aws_instance.kube-master.*.subnet_id}"]
  internal = true
 
  listener {
    instance_port     = 8080
    instance_protocol = "HTTP"
    lb_port           = 8080
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 5
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.kube-master.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 3600
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags {
    Name = "kube-internal-${var.vpc_tag}-api",
    Role = "kube-master-api"
  }
}

resource "aws_route53_zone" "kube_master_route53" {
  name   = "kube-master.ashishnepal.com"
  vpc_id = "${aws_vpc.kube_vpc.id}"
}

resource "aws_route53_record" "api" {
  zone_id = "${aws_route53_zone.kube_master_route53.zone_id}"
  name    = "api.kube-master.ashishnepal.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.kubemasterinternalapielb.dns_name}"
    zone_id                = "${aws_elb.kubemasterinternalapielb.zone_id}"
	evaluate_target_health = false
  }
}

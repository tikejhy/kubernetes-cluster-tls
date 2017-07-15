resource "aws_elb" "kubemasterapielb" {
  name               = "kube-${var.vpc_tag}-elb"
  security_groups    = ["${aws_security_group.elb.id}"]
  subnets = ["${aws_subnet.public-subnet.*.id}"]
 
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
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
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags {
    Name = "kube-${var.vpc_tag}-elb",
    Role = "kube-api-elb"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.kube_vpc.id}"
  tags {
        Name = "${var.vpc_tag}_internet_gateway"
    }
}

resource "aws_route" "project_internet_access" {
  route_table_id         = "${aws_vpc.kube_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_eip" "kube_vpc_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_subnet" "private-subnet" {
  vpc_id		= "${aws_vpc.kube_vpc.id}"
  cidr_block 		= "${lookup(var.private_subnet_cidr_blocks, format("zone%d", count.index))}"
  availability_zone 	= "${lookup(var.availability_zones, format("zone%d", count.index))}"
  map_public_ip_on_launch = false
  count = "${var.private_subnet_cidr_blocks["count"]}"
   tags = {
  	Name =  "private_subnet_${var.vpc_tag}_count_${count.index}"

  }
}

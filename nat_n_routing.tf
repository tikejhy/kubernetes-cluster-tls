resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.kube_vpc_eip.id}"
    subnet_id = "${aws_subnet.public-subnet.0.id}"
    depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.kube_vpc.id}"
 
    tags {
        Name = "Private_route_table_${var.vpc_tag}"
    }
}
 
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = "${aws_vpc.kube_vpc.default_route_table_id}"

  tags {
    Name = "Default_Public_Route_table_${var.vpc_tag}"
  }
}


resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}


# Associate subnet public_subnet_association to public route table
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"
    route_table_id = "${aws_vpc.kube_vpc.main_route_table_id}"
    count = 3
}

# Associate subnet private_subnet_association to private route table
resource "aws_route_table_association" "private_subnet_association" {
    subnet_id = "${element(aws_subnet.private-subnet.*.id,count.index)}"
    route_table_id = "${aws_route_table.private_route_table.id}"
    count = 3
}

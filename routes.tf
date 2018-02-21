resource "aws_default_route_table" "private" {
  default_route_table_id = "${aws_vpc.c_crypt.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.c_crypt.id}"
  }

  tags {
    Name = "c-crypt"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.c_crypt.id}"
  service_name = "com.amazonaws.${var.region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_default_route_table.private.id}"
}

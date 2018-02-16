resource "aws_subnet" "private" {
  count      = "${var.az_count}"
  vpc_id     = "${aws_vpc.c_crypt.id}"
  cidr_block = "${element(var.private_subnet_cidrs, count.index)}"

  tags {
    Name = "c-crypt private ${count.index}"
  }
}

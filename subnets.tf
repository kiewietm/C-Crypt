resource "aws_subnet" "https-gateway" {
  count      = "${var.az_count}"
  vpc_id     = "${aws_vpc.c_crypt.id}"
  cidr_block = "${element(var.https_subnet_cidrs, count.index)}"

  tags = "${merge(
            local.common_tags,
            map("Name", "c-crypt https ${count.index}")
          )}"
}

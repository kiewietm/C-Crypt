resource "aws_vpc" "c_crypt" {
  cidr_block = "${var.vpc_cidr}"
}

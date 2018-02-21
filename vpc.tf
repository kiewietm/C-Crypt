resource "aws_vpc" "c_crypt" {
  cidr_block = "${var.vpc_cidr}"

  tags = "${merge(
            local.common_tags,
            map("Name", "c-crypt")
          )}"
}

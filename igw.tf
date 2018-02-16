resource "aws_internet_gateway" "c_crypt" {
  vpc_id = "${aws_vpc.c_crypt.id}"

  tags {
    Name = "c_crypt"
  }
}

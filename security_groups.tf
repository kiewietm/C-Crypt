resource "aws_security_group" "rsa_lambda" {
  name        = "c-crypt-rsa-lambda"
  description = "Allow HTTPS and S3 endpoint"
  vpc_id      = "${aws_vpc.c_crypt.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["${data.aws_vpc_endpoint.s3.id}"]
  }

  tags = "${merge(
            local.common_tags,
            map("Name", "c-crypt rsa lambda")
          )}"
}

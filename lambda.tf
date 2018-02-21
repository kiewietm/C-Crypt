resource "aws_iam_role" "rsa" {
  name = "c-crypt-rsa-lamda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "rsaLambda"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rsa" {
  name = "c-crypt-rsa-lambda"
  role = "${aws_iam_role.rsa.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Effect": "Allow",
      "Resource": "*"
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "${aws_vpc.c_crypt.cidr_block}"
        }
      }
    }
  ]
}
EOF
}

variable "rsa_zip_name" {
  default = "generate_rsa"
}

data "archive_file" "rsa_lambda" {
  type        = "zip"
  source_file = "./lambda/generate_rsa.py"
  output_path = "./generate_rsa.zip"
}

resource "aws_lambda_function" "rsa" {
  filename         = "${var.rsa_zip_name}.${data.archive_file.rsa_lambda.type}"
  function_name    = "c-crypt-rsa"
  role             = "${aws_iam_role.rsa.arn}"
  handler          = "${var.rsa_zip_name}.my_handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.rsa_lambda.output_path}"))}"
  runtime          = "python3.6"

  kms_key_arn = "${aws_kms_key.secret.arn}"

  vpc_config {
    subnet_ids         = ["${aws_subnet.https-gateway.*.id}"]
    security_group_ids = ["${aws_security_group.rsa_lambda.id}"]
  }
}

resource "aws_iam_role" "aes" {
  name = "c-crypt-aes-lamda"

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
      "Sid": "aesLambda"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aes" {
  name = "c-crypt-aes-lambda"
  role = "${aws_iam_role.aes.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:CreateDocument",
        "ssm:DescribeDocument",
        "ssm:GetDocument",
        "ssm:UpdateDocument"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

variable "aes_zip_name" {
  default = "generate_aes"
}

data "archive_file" "aes_lambda" {
  type        = "zip"
  source_file = "./lambda/generate_aes.py"
  output_path = "./generate_aes.zip"
}

resource "aws_lambda_function" "aes" {
  filename         = "${var.aes_zip_name}.${data.archive_file.aes_lambda.type}"
  function_name    = "c-crypt-aes"
  role             = "${aws_iam_role.aes.arn}"
  handler          = "${var.aes_zip_name}.my_handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.aes_lambda.output_path}"))}"
  runtime          = "python3.6"

  kms_key_arn = "${aws_kms_key.secret.arn}"
}

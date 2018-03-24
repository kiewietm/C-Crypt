resource "aws_iam_role_policy_attachment" "aes" {
  role       = "${aws_iam_role.aes.name}"
  policy_arn = "${aws_iam_policy.aes_lambda.arn}"
}

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

variable "aes_encrypt_zip_name" {
  default = "aes_encrypt"
}

data "archive_file" "aes_encrypt_lambda" {
  type        = "zip"
  source_dir  = "./lambda/aes_encrypt/"
  output_path = "./${var.aes_encrypt_zip_name}.zip"
}

resource "aws_lambda_function" "aes_encrypt" {
  filename         = "${var.aes_encrypt_zip_name}.${data.archive_file.aes_encrypt_lambda.type}"
  function_name    = "c-crypt-aes-encrypt"
  role             = "${aws_iam_role.aes.arn}"
  handler          = "${var.aes_encrypt_zip_name}.my_handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.aes_encrypt_lambda.output_path}"))}"
  runtime          = "python2.7"

  #kms_key_arn = "${aws_kms_key.secret.arn}"
  #kms_key_arn = "arn:aws:kms:eu-west-3:931486170612:key/e67ba9f0-eb5a-403a-8bc7-2741870c4b9c"

  environment {
    variables = {
      KMS_ARN = "${aws_kms_key.secret.arn}"
    }
  }
}

variable "aes_decrypt_zip_name" {
  default = "aes_decrypt"
}

data "archive_file" "aes_decrypt_lambda" {
  type        = "zip"
  source_dir  = "./lambda/aes_decrypt/"
  output_path = "./${var.aes_decrypt_zip_name}.zip"
}

resource "aws_lambda_function" "aes_decrypt" {
  filename         = "${var.aes_decrypt_zip_name}.${data.archive_file.aes_decrypt_lambda.type}"
  function_name    = "c-crypt-aes-decrypt"
  role             = "${aws_iam_role.aes.arn}"
  handler          = "${var.aes_decrypt_zip_name}.my_handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.aes_decrypt_lambda.output_path}"))}"
  runtime          = "python2.7"

  #kms_key_arn = "arn:aws:kms:eu-west-3:931486170612:key/e67ba9f0-eb5a-403a-8bc7-2741870c4b9c"
  #kms_key_arn = "${aws_kms_key.secret.arn}"

  environment {
    variables = {
      KMS_ARN = "${aws_kms_key.secret.arn}"
    }
  }
}

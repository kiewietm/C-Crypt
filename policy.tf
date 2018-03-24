resource "aws_iam_policy" "aes_lambda" {
  name        = "c-crypt-aes-lambda"
  description = "C-Crypt AES Lambda"
  policy      = "${data.template_file.aes_lambda.rendered}"
}

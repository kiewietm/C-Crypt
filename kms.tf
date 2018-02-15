resource "aws_kms_key" "secret" {
  description         = "Key used to encrypt secrets"
  enable_key_rotation = true
  policy              = "${data.template_file.secret_kms.rendered}"
}

data "template_file" "secret_kms" {
  template = "${file("./policies/kms.json")}"

  vars {
    key_id           = "${jsonencode("c-crypt-secret")}"
    admin_principals = "${jsonencode(list(data.aws_caller_identity.current.arn))}"
    user_principals  = "${jsonencode(list(aws_iam_role.aes.arn))}"
  }
}

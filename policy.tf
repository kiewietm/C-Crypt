data "template_file" "secret_kms" {
  template = "${file("./policies/kms.json")}"

  vars {
    admin_principals = "${jsonencode(list("${data.aws_caller_identity.current.arn}"))}"
    user_principals  = "Lambda ARN"
  }
}

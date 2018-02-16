data "template_file" "secret_kms" {
  template = "${file("./policies/kms.json")}"

  vars {
    admin_principals = "${jsonencode(list("${data.aws_caller_identity.current.arn}"))}"
    user_principals  = "${aws_iam_role.rsa.arn}"
  }
}

data "template_file" "secret_bucket" {
  template = "${file("./policies/secret_s3.json")}"

  vars {
    bucket_name      = "${local.secret_bucket}"
    mfa_period       = "${var.mfa_period}"
    vpc_endpoint_ids = "${jsonencode(data.aws_vpc_endpoint.s3.id)}"
    trusted_role_ids = "${jsonencode(list(format("%s:*", aws_iam_role.rsa.unique_id)))}"
  }
}

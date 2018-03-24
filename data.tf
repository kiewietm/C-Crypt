data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "template_file" "aes_lambda" {
  template = "${file("./policies/aes_lambda.json")}"

  vars {
    region     = "${data.aws_region.current.name}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    kms_arn    = "${aws_kms_key.secret.arn}"
  }
}

data "template_file" "secret_kms" {
  template = "${file("./policies/kms.json")}"

  vars {
    key_id           = "${jsonencode("c-crypt-secret")}"
    admin_principals = "${jsonencode(list(data.aws_caller_identity.current.arn))}"
    user_principals  = "${jsonencode(list(aws_iam_role.aes.arn))}"
  }
}

resource "random_pet" "suffix" {}

resource "aws_s3_bucket" "website" {
  bucket        = "${local.website_bucket_name}"
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  #policy = "${data.aws_iam_policy_document.s3_policy.json}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": " Grant a CloudFront Origin Identity access to support private content",
            "Effect": "Allow",
            "Principal": {
                "CanonicalUser": "${aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id}"
            },
            "Action": [
                "s3:GetObject",
                "s3:List*"
            ],
            "Resource": "arn:aws:s3:::c-crypt-close-cicada/*"
        }
    ]
}
EOF

  provisioner "local-exec" {
    command = "aws s3 cp --recursive ./website/ s3://${local.website_bucket_name}/ --acl private --profile ${var.profile}"
  }
}

#data "aws_iam_policy_document" "s3_policy" {
#  statement {
#    actions   = ["s3:GetObject"]
#    resources = ["arn:aws:s3:::${local.website_bucket_name}/*"]
#
#    principals {
#      type        = "AWS"
#      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
#    }
#  }
#
#  statement {
#    actions   = ["s3:ListBucket"]
#    resources = ["arn:aws:s3:::${local.website_bucket_name}"]
#
#    principals {
#      type        = "AWS"
#      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
#    }
#  }
#}


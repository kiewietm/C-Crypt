resource "random_pet" "suffix" {}

resource "aws_s3_bucket" "website" {
  bucket        = "${local.website_bucket_name}"
  acl           = "private"
  force_destroy = true

  logging {
    target_bucket = "${aws_s3_bucket.logging.id}"
    target_prefix = "${var.log_prefix}"
  }

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
            "Resource": "arn:aws:s3:::${local.website_bucket_name}/*"
        }
    ]
}
EOF

  provisioner "local-exec" {
    command = "aws s3 cp --recursive ./website/ s3://${local.website_bucket_name}/ --acl private --profile ${var.profile}"
  }
}

resource "aws_s3_bucket" "logging" {
  bucket        = "${local.logging_bucket}"
  acl           = "log-delivery-write"
  force_destroy = true

  lifecycle_rule {
    prefix  = "${var.log_prefix}"
    enabled = true

    transition {
      days          = 7
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

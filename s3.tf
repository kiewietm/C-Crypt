resource "random_pet" "suffix" {}

resource "aws_s3_bucket" "website" {
  bucket        = "${local.website_bucket_name}"
  acl           = "public-read"
  force_destroy = true

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${local.website_bucket_name}/*"]
  }]
}
EOF
}

resource "random_pet" "suffix" {}

resource "aws_s3_bucket" "website" {
  bucket        = "${local.website_bucket_name}"
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

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

  provisioner "local-exec" {
    command = "aws s3 cp --recursive ./website/ s3://${local.website_bucket_name}/ --profile ${var.profile}"
  }
}

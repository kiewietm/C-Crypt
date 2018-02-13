output "s3-endpoint" {
  value = "${aws_s3_bucket.website.website_endpoint}"
}

output "cloudfront-endpoint" {
  value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "canonical-user-id" {
  value = "${aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id}"
}

resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "C-Crypt Website"
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "${var.origin_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "C-Crypt Website"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.logging.id}"
    prefix          = "${var.log_prefix}"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "POST"]
    cached_methods   = ["GET"]
    target_origin_id = "${var.origin_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = "${merge(
            local.common_tags,
            map("Name", "c-crypt website ${count.index}")
          )}"
}

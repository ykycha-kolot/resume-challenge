resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = "origin-access-control-tf"
  description                       = "Policy for CloudFront to access S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket_tf.bucket_regional_domain_name
    origin_id                = var.origin_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["www.${var.domain_name}"]
  default_cache_behavior {
    compress = true
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = [ "GET", "HEAD" ]
    cached_methods         = [ "GET", "HEAD" ]
    target_origin_id = var.origin_name
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward    = "all"
      }
    }
  }
  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.issued.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
}
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

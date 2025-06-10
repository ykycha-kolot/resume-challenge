resource "aws_route53_zone" "my_domain" {
  name = var.domain_name
}

resource "aws_acm_certificate" "domain_cert" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "certificate_record" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.my_domain.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_record : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
# uncomment after actions infrastructure setup to test
resource "aws_route53_record" "default" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
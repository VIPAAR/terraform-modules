data "aws_route53_zone" "domain" {
  name = "${var.hosted_zone_name}"
}

data "aws_acm_certificate" "certificate" {
  domain = "${var.acm_certificate_domain}"
}

resource "aws_cloudfront_origin_access_identity" "origin" {
  comment = "${var.distribution_name}"
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases           = [
    "${var.aliases}"
  ]
  comment           = "${var.comment}"
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cached_methods = [
      "GET",
      "HEAD"
    ]
    default_ttl             = 3600
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.redirector.qualified_arn}"
    }
    max_ttl                 = 86400
    min_ttl                 = 0
    target_origin_id        = "${var.distribution_name}"
    viewer_protocol_policy  = "redirect-to-https"
  }
  default_root_object = "${var.default_root_object}"
  depends_on          = [
    "aws_lambda_permission.redirector"
  ]
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "${var.price_class}"
  origin {
    domain_name = "${aws_s3_bucket.origin.bucket_domain_name}"
    origin_id   = "${var.distribution_name}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path}"
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn       = "${data.aws_acm_certificate.certificate.arn}"
    minimum_protocol_version  = "TLSv1.1_2016"
    ssl_support_method        = "sni-only"
  }
}

resource "aws_route53_record" "a_records" {
  alias {
    evaluate_target_health  = false
    name                    = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                 = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
  }
  count   = "${var.alias_count}"
  name    = "${var.aliases[count.index]}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
}

resource "aws_route53_record" "aaaa_records" {
  alias {
    evaluate_target_health  = false
    name                    = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                 = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
  }
  count   = "${var.alias_count}"
  name    = "${var.aliases[count.index]}"
  type    = "AAAA"
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
}

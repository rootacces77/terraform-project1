
############################
# Managed policies (AWS)
############################
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "Managed-SecurityHeadersPolicy"
}

############################
# OAC for S3 origin (recommended)
############################
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "oac-s3-cf-origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

############################
# CloudFront Distribution
############################
resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront with ALB + S3 origins"
  http_version    = "http2and3"
  price_class     = "PriceClass_100"

  aliases = var.aliases

  # Origins
  origin {
    origin_id   = "alb-origin"
    domain_name = var.alb_dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"   # CloudFront -> ALB uses HTTPS
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    origin_id                   = "s3-origin"
    domain_name                 = var.s3_bucket_regional_domain_name
    origin_access_control_id    = aws_cloudfront_origin_access_control.s3_oac.id
  }

  # Default behavior -> ALB (dynamic)
  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"  # HTTP -> HTTPS redirect

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    compress = true

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id

    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
  }

  # Static behavior -> S3 (example path)
  ordered_cache_behavior {
    path_pattern           = "/static/*"
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    compress = true

    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
  }

  # TLS/Cert
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # No geo restriction
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Recommended default
  default_root_object = ""  # set to "index.html" only if you want CF to serve it
}
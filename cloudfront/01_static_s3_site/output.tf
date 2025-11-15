output "cloudfront_01_static_s3_cdn_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

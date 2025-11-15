provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "cloudfront_01_static_s3_site" {
  bucket        = "cloudfront-01-static-s3-site"
  force_destroy = true

  tags = {
    Name        = "cloudfront-01-static-s3-site"
    Description = "S3 bucket containing your static website."
  }
}

resource "aws_s3_bucket_policy" "cloudfront_01_static_s3_bucket_policy" {
  bucket = aws_s3_bucket.cloudfront_01_static_s3_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Action = "s3:GetObject"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.cloudfront_01_static_s3_site.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cdn.id}"
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_control" "cloudfront_01_static_s3_oac" {
  name                              = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "CloudFront distribution for static S3 site"

  # S3 origin with OAC
  origin {
    origin_id                = "s3-origin"
    domain_name              = aws_s3_bucket.cloudfront_01_static_s3_site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_01_static_s3_oac.id
  }

  # Default cache behavior
  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  # Price class - use only North America and Europe
  price_class = "PriceClass_100"

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "cloudfront-01-static-s3-cdn"
    Description = "CloudFront distribution for static S3 website"
  }
}

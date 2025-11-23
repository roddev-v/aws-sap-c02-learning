resource "aws_s3_bucket" "assets_bucket" {
  bucket = "assets"
}

resource "aws_s3_bucket_public_access_block" "block_public_assets" {
  bucket = aws_s3_bucket.assets_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.assets_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudfrontSignedUrlPrincipal"
        Effect = "Allow"
        Action = "s3:GetObject"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.assets_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.assets_distribution.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_public_key" "signed_url_public_key" {
  name        = "signer-url-public-key"
  encoded_key = file("${path.module}/keys/public_key.pem")
}

resource "aws_cloudfront_distribution" "assets_distribution" {
  enabled     = true
  price_class = "PriceClass_100"

  default_cache_behavior {
    target_origin_id       = "s3-assets-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }
  origin {
    origin_id                = "s3-assets-origin"
    domain_name              = aws_s3_bucket.assets_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "S3 Cloudfront OAC for signed URLs"
  description                       = "Allows only signed URLs to access bucket content"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

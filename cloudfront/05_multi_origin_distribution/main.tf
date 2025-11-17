resource "aws_s3_bucket" "static-website" {
  bucket        = "cloudfront-s05-static-website-bucket"
  force_destroy = true
}

resource "aws_s3_bucket" "static-assets" {
  bucket        = "cloudfront-s05-static-assets-bucket"
  force_destroy = true
}

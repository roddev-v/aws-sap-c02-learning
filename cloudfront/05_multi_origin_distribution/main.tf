resource "aws_s3_bucket" "static-website" {
  bucket        = "cloudfront-05-static-website-bucket"
  force_destroy = true
}

resource "aws_s3_bucket" "static-assets" {
  bucket        = "cloudfront-05-static-assets-bucket"
  force_destroy = true
}

module "cloudfront_01_static_s3_site" {
  source = "./cloudfront/01_static_s3_site"
}

module "cloudfornt_02_api_gateway" {
  source = "./cloudfront/02_api_gateway"
}

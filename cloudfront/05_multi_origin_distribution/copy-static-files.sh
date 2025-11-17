#!/bin/bash

STATIC_WEBSITE_BUCKET="s3://cloudfront-05-static-website-bucket/"
STATIC_ASSETS_BUCKET="s3://cloudfront-05-static-assets-bucket/"

aws s3 sync ./static-website "$STATIC_WEBSITE_BUCKET" --cache-control "max-age=3600, s-maxage=86400"
aws s3 cp ./static-website/index.html "$STATIC_WEBSITE_BUCKET" --cache-control "max-age=0, s-maxage=60"

aws s3 sync ./static-assets "$STATIC_ASSETS_BUCKET" --cache-control "max-age=3600, s-maxage=86400"
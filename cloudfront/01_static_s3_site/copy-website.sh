#!/bin/bash

BUCKET="s3://cloudfront-01-static-s3-site/"

aws s3 sync ./website "$BUCKET" --cache-control "max-age=3600, s-maxage=86400"
aws s3 cp ./website/index.html "$BUCKET" --cache-control "max-age=0, s-maxage=60"
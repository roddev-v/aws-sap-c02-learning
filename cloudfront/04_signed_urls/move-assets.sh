#!/bin/bash

BUCKET="s3://assets-sap-co2-practice/"

aws s3 sync ./assets "$BUCKET" --cache-control "max-age=3600, s-maxage=86400"

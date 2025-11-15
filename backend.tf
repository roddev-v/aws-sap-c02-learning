terraform {
  backend "s3" {
    bucket         = "aws-sap-c02-learning-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
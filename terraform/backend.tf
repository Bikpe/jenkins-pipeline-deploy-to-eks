terraform {
  backend "s3" {
    bucket = "primuslearning-app-bikpe001"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}
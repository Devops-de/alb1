provider "aws" {
  region = "us-east-1"
}

terraform {
    backend "s3" {
      encrypt = true
      bucket = "aftp-terraform-statefile"
      dynamodb_table = "terraform-state-lock-table"
      key = "infra/terraform.tfstate"
      region = "us-east-1"
  }
}
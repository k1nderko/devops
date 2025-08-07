terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-bucket"
    key            = "devops/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
} 
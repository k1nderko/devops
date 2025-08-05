terraform {
  backend "s3" {
    bucket         = "k1nderko-terraform-backend"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
} 
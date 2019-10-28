terraform {
  backend "s3" {
    bucket = "test-helene"
    key    = "terraform"
  }
}

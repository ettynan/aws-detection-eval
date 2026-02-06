resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_user" "test_user" {
  name = "baseline-test-user"
}
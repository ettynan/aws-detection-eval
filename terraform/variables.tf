variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS CLI profile used by Terraform"
  type        = string
  default     = "aws-detection-eval"
}

variable "bucket_name" {
  description = "S3 bucket for logging and test artifacts"
  type        = string
}

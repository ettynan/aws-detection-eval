#############################################
# AWS Config – Basic Recording Setup
#
# Purpose:
# Enable AWS Config to record configuration
# changes for supported resources.
#
# Requirements:
# 1. IAM role AWS Config can assume
# 2. Configuration recorder
# 3. Delivery channel (S3 bucket)
# 4. Start recorder
#
# Using existing S3 log bucket.
#############################################

#############################################
# IAM Role for AWS Config
#############################################

resource "aws_iam_role" "config_role" {
  name = "aws-config-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#############################################
# Attach AWS Managed Policy
#############################################

resource "aws_iam_role_policy_attachment" "config_role_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

#############################################
# Configuration Recorder
#############################################

resource "aws_config_configuration_recorder" "main" {
  name     = "default"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported = true
  }
}

#############################################
# Delivery Channel (Must wait for Recorder)
#############################################

resource "aws_config_delivery_channel" "main" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.log_bucket.id

  depends_on = [
    aws_config_configuration_recorder.main
  ]
}

#############################################
# Start Recorder (Must wait for Delivery Channel)
#############################################

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.main
  ]
}

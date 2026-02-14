#############################################
# CloudTrail – Management Events Only
#
# Purpose:
# Enable account-level management event logging.
# No data events.
# No CloudWatch integration.
# Logs stored in existing S3 bucket.
#############################################

resource "aws_cloudtrail" "management_trail" {
  name                          = "management-events-trail"
  s3_bucket_name                = aws_s3_bucket.log_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}

#############################################
# Required S3 Bucket Policy for CloudTrail
#
# CloudTrail must have permission to:
# - Check bucket ACL
# - Write log files to the bucket
#
# AWS Config must ALSO have permission to:
# - Check bucket ACL
# - Write configuration snapshots
#
# Without these permissions, service creation fails.
#############################################

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cloudtrail_s3_policy" {

  #############################################
  # Allow CloudTrail to verify bucket ACL
  #############################################

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.log_bucket.arn
    ]
  }

  #############################################
  # Allow CloudTrail to write log files
  #############################################

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.log_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    # Required ACL condition
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    # CloudTrail enforces SourceArn validation
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudtrail.management_trail.arn]
    }
  }

  #############################################
  # Allow AWS Config to verify bucket ACL
  #############################################

  statement {
    sid    = "AWSConfigAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.log_bucket.arn
    ]
  }

  #############################################
  # Allow AWS Config to write configuration data
  #############################################

  statement {
    sid    = "AWSConfigWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.log_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    # Required ACL condition
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_s3_policy.json
}

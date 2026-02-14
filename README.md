# AWS Detection Evaluation Project

This repository contains infrastructure and documentation for a  project evaluating AWS-native security detection capabilities in a minimally configured environment.

## Project Scope
- Provision a minimal AWS test environment using Terraform
- Enable and observe AWS-native detection tools (e.g., CloudTrail, GuardDuty, AWS Config)
- Simulate common cloud security issues
- Evaluate alert clarity and usefulness for resource-limited teams

## Repository Structure
- `terraform/` – Terraform configuration for provisioning the AWS test environment
- Documentation and analysis artifacts will be added in later milestones

## Execution Model and Variable Usage

This project intentionally avoids hardcoding resource names, particularly the S3 log bucket.  
The bucket name is passed explicitly at runtime using a Terraform variable.

Example:
```bash
terraform plan -var="bucket_name=<unique-bucket-name>"
terraform apply -var="bucket_name=<unique-bucket-name>"
```
This design ensures:

- Globally unique S3 bucket names (required by AWS)
- No forced bucket replacement during subsequent applies
- Clear separation between infrastructure code and environment-specific values

All Terraform operations in this project assume explicit variable passing for `bucket_name`.

## Status
- Milestone 1: Minimal AWS environment provisioned using Terraform (completed)

## Milestone 1: Test Environment Provisioning and Baseline Verification

Milestone 1 establishes a minimal, stable AWS test environment that serves as the foundation for all subsequent evaluation work. The purpose of this milestone is to verify that infrastructure provisioning functions correctly, that Terraform is authenticated to the intended AWS account, and that a small baseline environment exists before enabling any AWS-native detection services or executing threat simulations.

The environment created during this milestone is intentionally minimal. No AWS-native security tooling is enabled, and no adversarial activity or misconfiguration is introduced at this stage. This milestone focuses exclusively on controlled setup and verification to ensure later observations can be attributed to detection tooling rather than infrastructure or configuration errors.

## Completion Checklist

- [x] AWS account created and accessible  
- [x] Programmatic access configured via a dedicated IAM user for Terraform  
- [x] Local AWS CLI profile configured and verified against the correct AWS account  
- [x] Terraform project structure created and initialized  
- [x] AWS provider configured with a pinned version to ensure reproducibility  
- [x] Minimal AWS resources provisioned using Terraform:
  - One S3 bucket with a globally unique name
  - One baseline IAM user  
- [x] Terraform plan and apply completed successfully with no unexpected changes  
- [x] Resources verified to exist only in the intended AWS account  

The test environment is now stable and ready for enabling AWS-native detection tools and performing controlled threat simulations in subsequent milestones.


## Milestone 2: Enable AWS-Native Detection and Logging Services (Minimal)

### Step 1: IAM Access Analyzer Enabled

IAM Access Analyzer was enabled at the account scope using Terraform. This establishes baseline monitoring for external and cross-account access exposure across supported AWS resources. The analyzer operates at the account level and does not modify or attach to specific infrastructure resources.

Terraform plan confirmed a single resource addition with no changes or replacements. Terraform apply completed successfully.

**Verification:**
- [x] Access Analyzer status: Active
- [x] Scope: ACCOUNT
- [x] Region: us-west-2
- [x] No findings present at baseline

##  Step 2: Enable AWS-Native Detection Services (CloudTrail)


Enable AWS CloudTrail using Terraform to capture management events only, with minimal configuration and no advanced tuning.

### Configuration Scope

CloudTrail was configured with the following characteristics:

- Management events only
- Multi-region trail enabled
- Logs delivered to existing S3 bucket
- No data events enabled
- No CloudWatch integration
- No SNS notifications
- No KMS encryption
- No advanced log validation features

---

### Implementation Notes

CloudTrail requires explicit S3 bucket permissions before it can be created. Two S3 policy validation errors occurred during implementation.

#### Failure 1 – Missing S3 Bucket Policy 

CloudTrail could not write logs to the S3 bucket because no bucket policy existed allowing access.

Resolution:
Added a bucket policy granting the `cloudtrail.amazonaws.com` service principal permission to:

- `s3:GetBucketAcl`
- `s3:PutObject`
- Service principal: `cloudtrail.amazonaws.com`
- Correct `/AWSLogs/<account-id>/*` path

---

#### Failure 2 – Missing `aws:SourceArn` Condition

After adding basic permissions, AWS rejected the bucket policy as insufficient.

Root cause:
AWS requires explicit validation of the source CloudTrail trail ARN in the bucket policy.

Resolution:
Added the required condition to the `s3:PutObject` statement:

```hcl
condition {
  test     = "StringEquals"
  variable = "aws:SourceArn"
  values   = [aws_cloudtrail.management_trail.arn]
}
```
This restricts log delivery to the specific CloudTrail trail.


**Verification:**

- [x] Terraform apply completed successfully
- [x] CloudTrail trail `management-events-trail` exists in AWS Console
- [x] CloudTrail status shows **Logging**
- [x] S3 bucket policy includes:
  - `cloudtrail.amazonaws.com`
  - `s3:PutObject`
  - `aws:SourceArn`
- [x] Log files observed in S3 under `/AWSLogs/<account-id>/`
- [x] No manual console configuration was required


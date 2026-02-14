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
- Access Analyzer status: Active
- Scope: ACCOUNT
- Region: us-west-2
- No findings present at baseline

## SCENARIO 3 – Public S3 Bucket Exposure

Does AWS-native detection tooling detect the exposure of an S3 bucket to public anonymous access under default configuration?

#### Region:

us-west-2

#### Action performed:

Created S3 bucket test-public-s3-bucket-expose-et, modified bucket policy to allow public anonymous access, and adjusted public access block settings.

#### Action timestamp (UTC)

Fri Feb 27 00:23:46 UTC 2026

#### GuardDuty

Detected? Yes – High severity finding generated for public anonymous access

#### CloudTrail

Event recorded? Yes – Events shown in us-west-2 including CreateBucket, PutBucketPolicy, PutBucketPublicAccessBlock, and related S3 management actions

#### AWS Config

Change recorded? Yes – S3 bucket visible in Resource Inventory in us-west-2

#### Access Analyzer

Finding? Yes – Bucket listed under Key resources with public access marked as “Allow”

#### Notes

Bucket policy explicitly granted public anonymous access. Access Analyzer reflected public exposure at the resource level, and GuardDuty generated a High severity finding tied to the exposure event.

#### Summary

The S3 bucket test-public-s3-bucket-expose-et was created and configured to allow public anonymous access as the test action. CloudTrail recorded the associated management events in us-west-2, including CreateBucket, PutBucketPolicy, and public access configuration changes. AWS Config surfaced the S3 bucket in the regional Resource Inventory, confirming recording of the resource and its configuration state. IAM Access Analyzer identified the bucket under Key resources with public access marked as “Allow,” and GuardDuty generated a High severity finding indicating that public anonymous access had been granted.

AWS Config surfaced the S3 bucket in Scenario 3 because S3 is a regional resource and its configuration state changes, such as public access settings and bucket policy updates, are directly recorded in the regional Config Resource Inventory. In contrast, the IAM role creation in Scenario 1 and the MFA removal in Scenario 2 involved IAM, which is a global service, and those specific configuration changes did not result in visible configuration items in the regional view despite recording being enabled. More importantly, AWS Config records resource configuration state but does not evaluate policy permissiveness or MFA enforcement unless explicit compliance rules are deployed. By default, the service measures resource configuration attributes rather than authentication hygiene or least-privilege posture, which explains why S3 exposure was clearly surfaced while IAM permissiveness and MFA removal were not.

These observations indicate that under default configuration, public S3 bucket exposure is detected and surfaced by multiple AWS-native services as a security-relevant event.
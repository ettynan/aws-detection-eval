## SCENARIO 2 – Disabled MFA

Does AWS-native detection tooling detect the removal of multi-factor authentication (MFA) from an IAM user under default configuration?

#### Region: 
us-west-2

#### Action performed:
Created IAM user test-mfa-disabled-user, enabled virtual MFA device, then removed MFA device

#### Action timestamp (UTC)
Thu Feb 26 22:30:30 UTC 2026

#### GuardDuty
Detected? No new findings related to MFA removal

#### CloudTrail
Event recorded? None shown in us-west-2. Shown in N. Virginia since that is where it is recorded (per AWS). DeactivateMFADevice and DeleteVirtualMFADevice events observed.

#### AWS Config
Change recorded? No

#### Access Analyzer
Finding? None

#### Notes
MFA device was successfully removed from the test IAM user. No console warnings were displayed during removal.

#### Summary
The IAM user test-mfa-disabled-user was created, assigned a virtual MFA device, and then had the MFA device removed as the test action. GuardDuty produced no findings related to MFA removal; only recurring low-severity findings related to root credential usage were present and consistent with baseline activity. CloudTrail Event History in us-east-1 recorded DeactivateMFADevice and DeleteVirtualMFADevice management events associated with test-mfa-disabled-user, consistent with IAM being a global service and CloudTrail recording global service management events in the us-east-1 N. Virginia region. AWS Config recording was verified as enabled; however, no compliance changes or configuration alerts were surfaced for the IAM user after MFA removal, and advanced query results did not indicate any noncompliant resource state. Access Analyzer was reviewed using the existing account-level analyzer, and no active findings were generated for the MFA removal action.

These observations indicate that under default configuration, MFA removal for an IAM user is logged but not surfaced as an actionable security finding by AWS-native detection services.
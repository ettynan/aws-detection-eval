## SCENARIO 1 – Overly Permissive IAM Role
Does AWS-native detection tooling detect the creation of an overly permissive IAM role under default configuration?

#### Region: us-west-2

#### Action performed:
Created IAM role test-overpermissive-role with inline policy allowing Action: "\*" and Resource: "\*"

#### Action timestamp (UTC)
Tue Feb 24 00:47:10 UTC 2026

#### GuardDuty
Detected? No new findings related to role creation

#### CloudTrail
Event recorded? None shown in Us-west-2. Shown in N. Virginia since that is where it is recorded (per aws)

#### AWS Config
Change recorded? No

#### Access Analyzer
Finding? None

#### Notes
IAM console displayed Security and Policy validation warnings prior to saving inline policy indicating overly permissive configuration.

#### Summary 
The IAM role test-overpermissive-role was created with an inline policy granting wildcard permissions for both Action and Resource. During policy creation, the IAM console displayed built-in security and validation warnings indicating that the configuration was overly permissive. GuardDuty produced no findings related to the creation of the overly permissive role; only pre-existing low-severity findings related to root credential usage were present. CloudTrail Event History in us-east-1 recorded CreateRole, PutRolePolicy, DeleteRolePolicy, and DeleteRole events associated with test-overpermissive-role, consistent with IAM being a global service and CloudTrail recording global service management events in the us-east-1 N. Virginia region. AWS Config recording was verified as enabled with continuous recording of all supported resource types; however, no configuration items for the test role were visible in the Resources view, and an advanced query for AWS::IAM::Role returned no results during the evaluation window. Access Analyzer was reviewed using the existing account-level analyzer, and no active findings were generated for the overly permissive IAM role.

These observations suggest limited default detection or visibility for IAM misconfiguration under the tested conditions.


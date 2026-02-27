## SCENARIO 4 – Privilege Escalation Attempt
Does AWS-native detection tooling detect the attachment of an AdministratorAccess policy to a baseline IAM user under default configuration?

#### Region:
us-west-2

#### Action performed:
Created IAM user test-privilege-escalation-user and attached the AdministratorAccess managed policy.

#### Action timestamp (UTC)
Fri Feb 27 05:29:51 UTC 2026

#### GuardDuty
Detected? No – No findings generated related to the AdministratorAccess attachment

#### CloudTrail
Event recorded? Yes – CreateUser and AttachUserPolicy management events recorded

#### AWS Config
Change recorded? No – Advanced query for AWS::IAM::User returned no results in the regional scope

#### Access Analyzer
Finding? No – No findings generated for the attached AdministratorAccess policy

#### Notes
AdministratorAccess was successfully attached to the IAM user. The action was confirmed in IAM and recorded in CloudTrail.

#### Summary
The IAM user test-privilege-escalation-user was created and subsequently granted the AdministratorAccess managed policy as the test action. CloudTrail recorded both the CreateUser and AttachUserPolicy management events, confirming that the privilege escalation occurred and was logged. AWS Config advanced query in us-west-2 returned no configuration item for the IAM user following the policy attachment. IAM Access Analyzer produced no findings because attaching AdministratorAccess to a user within the same account does not create public or cross-account access. GuardDuty generated no findings related to the policy attachment. In this scenario, the privilege escalation was logged but not interpreted as a security finding under default configurations. CloudTrail recorded the management events without evaluating risk or assigning severity. AWS Config measures resource configuration state but does not inherently assess whether an attached managed policy represents excessive privilege unless explicit compliance rules are configured. Access Analyzer evaluates external and cross-account access conditions rather than internal privilege scope, and therefore did not surface the AdministratorAccess attachment. As a result, the escalation was visible at the logging level but not surfaced as an actionable security event by AWS-native detection services.

These observations indicate that under default configuration, internal privilege escalation through attachment of AdministratorAccess is logged but not surfaced as a security-relevant finding by AWS-native detection tools.
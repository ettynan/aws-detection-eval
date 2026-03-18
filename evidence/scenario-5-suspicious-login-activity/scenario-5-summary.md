## SCENARIO 5 – Suspicious Login Activity
Does AWS-native detection tooling detect authentication activity involving geographic deviation, failed authentication attempts, and repeated login behavior under default configuration?

#### Region:
us-west-2

#### Action performed:
Created IAM user test-suspicious-auth-user and simulated authentication activity across multiple conditions:
- Baseline API authentication from Washington IP
- API authentication from foreign IP (Frankfurt)
- Failed API authentication attempts (incorrect secret)
- Successful API authentication from foreign IP
- Failed console login attempts (2 attempts)
- Repeated failed API authentication attempts (100 attempts, foreign IP)
- Repeated failed console login attempts (15 consecutive attempts)

#### Action timestamp (UTC)
- User creation: Tue Mar 17 20:03:37 UTC 2026
- Foreign failed API attempts: Tue Mar 17 21:06:05–21:07:59 UTC 2026
- Foreign successful API authentication: Tue Mar 17 21:10:10–21:10:41 UTC 2026
- Failed console login attempts (2): Tue Mar 17 23:26:34–23:26:56 UTC 2026
- 100 failed API attempts: Wed Mar 18 01:53:40 UTC 2026
- 15 failed console login attempts: Wed Mar 18 02:17:24 UTC 2026

#### GuardDuty
Detected? No – Detected? No – No findings generated related to foreign IP activity, failed authentication attempts, or repeated login attempts; only unrelated low-severity root credential usage findings present

#### CloudTrail
Event recorded? artial – Successful API authentication events (ListUsers) were recorded; failed API authentication attempts using incorrect secrets were not recorded due to request-signing failure; failed console login attempts (including 15 consecutive attempts) were not observed in Event History for the IAM user

#### AWS Config
Change recorded? No – No configuration changes recorded; authentication activity does not modify resource state and IAM resource types were not captured under current recording settings

#### Access Analyzer
Finding? No – No findings generated; authentication behavior and geographic deviation are not evaluated under analyzer criteria

#### Notes
Authentication activity was successfully generated across both local and foreign IP environments. Successful API calls from the foreign IP were logged in CloudTrail, confirming that geographic deviation does not prevent logging when authentication succeeds. Failed API authentication attempts using incorrect credentials resulted in SignatureDoesNotMatch errors and were rejected before reaching IAM identity context, preventing CloudTrail logging. Failed console login attempts produced consistent authentication error messages, including during 15 consecutive attempts, but did not generate observable logging or detection signals. No account lockout behavior was observed.

#### Summary
The IAM user test-suspicious-auth-user was used to simulate authentication activity across multiple dimensions, including geographic deviation, authentication method, success versus failure, and repeated attempts. CloudTrail recorded successful authenticated API activity from both local and foreign IP addresses, confirming that valid authentication events are logged regardless of origin. However, failed API authentication attempts using incorrect credentials were rejected at the request-signing layer and did not generate CloudTrail events due to the absence of an associated IAM identity. Failed console login attempts, including a sequence of 15 consecutive attempts, did not produce observable ConsoleLogin events for the IAM user in CloudTrail Event History. GuardDuty generated no findings related to any authentication behavior tested, including foreign-origin access and repeated failures. AWS Config recorded no configuration changes, and IAM Access Analyzer produced no findings, as neither service evaluates authentication behavior under default configurations.

These observations indicate that under default configuration, AWS-native detection tools provide limited visibility into authentication-related anomalies. Successful authentication activity is logged in CloudTrail, but failed authentication attempts and repeated login behavior may not produce detectable signals. Geographic deviation and repeated failures are not elevated to actionable security findings by GuardDuty, and no supporting context or interpretation is provided by other services. As a result, authentication anomalies remain largely unobserved beyond basic logging of successful events. These observations indicate that under default configuration, internal privilege escalation through attachment of AdministratorAccess is logged but not surfaced as a security-relevant finding by AWS-native detection tools.
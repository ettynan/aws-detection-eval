#############################################
# GuardDuty – Minimal Enablement
#
# Purpose:
# Enable GuardDuty detector for this account
# using default settings.
#
# No organization members
# No suppression rules
# No custom configuration
# No export destinations
#############################################

resource "aws_guardduty_detector" "main" {
  enable = true
}

# This file manages assemly of resource IDs that have been provisioned and managed into
# a Terraform map that can be reused elsewhere for outputs as part of a larger stack or
# as inputs to a dependant stack
#
# Use Case #1: Output generation. Consumers are external
#
#   In these use-cases, we are provisioning and managing resources that will be used or
#   consumed by workloads and services that are external to our stack. Good examples of
#   this use-case are provision a default set of KMS Keys when performing initial setup
#   of an AWS Account
#
#                 ___ (KMS Key for CloudTrail use)
#                |
#       Stack <--|--- (KMS Key for Service Logging use)
#                |
#                |___ (KMS Key for EBS Backup use)
#
#   To be more helpful to the user we can combine the resource IDs into more human
#   friendly output.
#
#
# Use Case #2: Combined usage. Consumers are also Terraform, possibly in the same stack
#
#   In these use-cases, we are provisioning and managing resources that will be used or
#   consumed by workloads and services that are also local to our stack. To be more helpful
#   to the user we can combine the resource IDs into more easily accessable lookup, keyed
#   by their unit_id. Only attributes that be useful in other Terraform code should be added
#   and published
#
#
#   resources = {
#     "res-key-kubernetes-01" = {
#       "arn" = "arn:aws:res:eu-west-1:123456753244:key/802f518f-6545-4734-9e13-1234"
#       "id" = "res-key-kubernetes-01"
#       "res_id" = "802f518f-6545-4734-9e13-0557a1af294b"
#     }
#     "res-key-kubernetes-02" = {
#       "arn" = "arn:aws:res:eu-west-1:123456753244:key/2cd6d331-6a78-4d20-bcff-1234"
#       "id" = "res-key-kubernetes-02"
#       "res_id" = "2cd6d331-6a78-4d20-bcff-1234"
#     }
#   }
#

output "resources" {
  value = {
    role_name = aws_iam_role.pattern.name
    role_arn  = aws_iam_role.pattern.arn

    security_third_party_secret = local.config_overlay.pattern_payload.third_party_secret
    security_require_mfa        = local.config_overlay.pattern_payload.third_party_requires_mfa
    security_role_ipal          = local.config_overlay.pattern_payload.third_party_ipal

  }
}



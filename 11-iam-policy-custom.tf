
data "template_file" "custom_policy" {

  count = (
    local.config_overlay.pattern_features.custom_iam_role_policy.enabled
    # If feature enabled
    ? 1
    # If feature not enabled
    : 0
  )

  template = local.config_overlay.pattern_features.custom_iam_role_policy.content

  vars = {
    # Add our helper variables by default
    AWS_ACCOUNT_NUMBER = local.dynamic_data.aws_caller_identity.account_id
    AWS_USER_ID        = local.dynamic_data.aws_caller_identity.user_id
    AWS_USER_ARN       = local.dynamic_data.aws_caller_identity.arn
    AWS_REGION_ID      = local.dynamic_data.aws_region.id
    AWS_REGION_NAME    = local.dynamic_data.aws_region.name
  }

}


resource "aws_iam_policy" "custom_policy" {

  count = (
    local.config_overlay.pattern_features.custom_iam_role_policy.enabled
    # If feature enabled
    ? 1
    # If feature not enabled
    : 0
  )

  name = format("%s-XA-Custom-%s-%s",
    local.config_overlay.common_config.global_resource_prefix,
    local.config_overlay.pattern_payload.third_party_id,
    local.config_overlay.stack_id
  )

  description = "IAM policy for external service provider acccess"
  policy      = data.template_file.custom_policy[0].rendered

}
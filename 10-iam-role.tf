resource "aws_iam_role" "pattern" {

  name = format("%s-XA-Role-%s-%s",
    local.config_overlay.common_config.global_resource_prefix,
    local.config_overlay.pattern_payload.third_party_id,
    local.config_overlay.stack_id
  )

  assume_role_policy   = data.aws_iam_policy_document.combined_sp_policy_trust.json
  max_session_duration = local.config_overlay.pattern_payload.max_session_duration

}


resource "aws_iam_role_policy_attachment" "custom_policy_attachments_by_arn" {

  count = (
    local.config_overlay.pattern_features.iam_role_policy_attachments.enabled
    # If feature enabled
    ? length(local.config_overlay.pattern_features.iam_role_policy_attachments.arns)
    # If feature not enabled
    : 0
  )

  role       = aws_iam_role.pattern.name
  policy_arn = local.config_overlay.pattern_features.iam_role_policy_attachments.arns[count.index]

}


resource "aws_iam_role_policy_attachment" "custom_policy_attachments" {

  count = (
    local.config_overlay.pattern_features.custom_iam_role_policy.enabled
    # If feature enabled
    ? 1
    # If feature not enabled
    : 0
  )

  role       = aws_iam_role.pattern.name
  policy_arn = aws_iam_policy.custom_policy[0].arn

}


data "aws_iam_policy_document" "allow_sp_assume_role" {
  count = local.config_overlay.pattern_payload.third_party_secret != null ? 1 : 0

  statement {

    sid    = "SPAllow"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.config_overlay.pattern_payload.third_party_aws_arns
    }

    actions = [
      "sts:AssumeRole"
    ]

    # Add a condition if we have an external-id
    dynamic "condition" {
      for_each = [local.config_overlay.pattern_payload.third_party_secret]
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }

  }

}


data "aws_iam_policy_document" "restrict_sp_by_source" {
  count = local.config_overlay.pattern_payload.third_party_ipal != null ? 1 : 0

  statement {

    sid    = "SPDenyUnlessValidSource"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = local.config_overlay.pattern_payload.third_party_aws_arns
    }

    actions = [
      "sts:AssumeRole"
    ]

    # Add a condition if we have an external-id
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = local.config_overlay.pattern_payload.third_party_ipal
    }

  }

}


data "aws_iam_policy_document" "require_sp_mfa" {

  statement {

    sid    = "SPDenyUnlessMFA"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = local.config_overlay.pattern_payload.third_party_aws_arns
    }

    actions = [
      "sts:AssumeRole"
    ]

    # Add a condition if we have an external-id
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = [local.config_overlay.pattern_payload.third_party_requires_mfa]
    }

  }

}


data "aws_iam_policy_document" "combined_sp_policy_trust" {

  source_policy_documents = [

    (
      local.config_overlay.pattern_payload.third_party_secret != null
      ? data.aws_iam_policy_document.allow_sp_assume_role[0].json
      : ""
    ),

    (
      local.config_overlay.pattern_payload.third_party_ipal != null
      ? data.aws_iam_policy_document.restrict_sp_by_source[0].json
      : ""
    ),

    (
      local.config_overlay.pattern_payload.third_party_requires_mfa
      ? data.aws_iam_policy_document.require_sp_mfa.json
      : ""
    )

  ]

}
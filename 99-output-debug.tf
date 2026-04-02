# These resources generate local files and are intended for debugging and troubleshooting only

resource "local_file" "pattern_debug" { # tflint-ignore: terraform_required_providers

  count = local.config_overlay.common_config.debug_enabled ? 1 : 0

  content = provider::tfutils::json_format(
    jsonencode({
      config_overlay = local.config_overlay,
      dynamic_data   = local.dynamic_data
  }))

  filename = format("fab4c/debug/debug_pattern_%s.json", local.pattern_id)

}
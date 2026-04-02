##############################################################################
# Summary:
#
# This file handles the majority of the configuration assembly for normal
# pattern usage, combining user-provided values with both discovered values
# (data sources) and internal pattern defaults
#
# No changes should be required to this file for normal pattern development
#
##############################################################################

# Randomized identifier at a pattern level for use with shared pattern level resources
# tied to the resource prefix
resource "random_id" "shared_resources" {
  keepers = {
    pattern_id = local._resource_prefix
  }
  byte_length = 4
}


locals {

  # Internal pattern defaults
  _defaults_yaml = file("${path.module}/conf.d/defaults.yml")

  # Internal pattern lookup tables for AWS
  _lut_aws = yamldecode(file("${path.module}/conf.d/fab4c-lut-aws.yml"))

  # User-provided config, decoded so we can splice it's content
  _user_config_content = yamldecode(file(var.configuration_file))

  # Extract the config for this specific pattern - the file may hold configuration for more than one pattern
  _user_pattern_config = lookup(local._user_config_content, local.pattern_id, {})

  # Discard any user settings for a feature that is not enabled by the user by creating a
  # map as a mask to filter out the user settings for any feature which is not enabled
  _feature_settings_mask = {
    for key, value in lookup(local._user_pattern_config, "pattern_features", {})
    : key => { enabled : value.enabled } if value.enabled == false
  }

  # Reassemble the user config for overlay assembly using the mask to filter out unwanted settings from user
  _user_config = {
    common_config    = lookup(local._user_config_content, "common_config", {})
    pattern_features = merge(lookup(local._user_pattern_config, "pattern_features", {}), local._feature_settings_mask)
    pattern_payload  = lookup(local._user_pattern_config, "pattern_payload", {})
  }

  # This overlay now contains the merged result of built-in defaults and user-provided config
  # We will build all over resources from this source of truth
  _decoded_overlay = yamldecode(
    provider::tfutils::yaml_deepmerge(
      local._defaults_yaml,
      yamlencode(local._user_config)
    )
  )

  # Extract the prefix tokens so we can build two prefixes, respecting the token order is the user changed it
  _prefix_token_order = local._decoded_overlay.common_config.prefix_token_order

  # Regional resource prefix
  _regional_prefix_tokens = merge(
    { location = lookup(local._lut_aws.aws_region_to_shortcode, data.aws_region.current.name, "ASSERT-NO-LUT-MAPPING") },
    local._decoded_overlay.common_config.prefix_tokens
  )
  _resource_prefix = join("-", compact([for item in local._prefix_token_order : lookup(local._regional_prefix_tokens, item, null)]))

  # Global resource prefix
  _global_prefix_tokens = merge(
    { location = lookup(local._lut_aws.aws_region_to_shortcode, "global", "ASSERT-NO-LUT-MAPPING") },
    local._decoded_overlay.common_config.prefix_tokens
  )
  _global_resource_prefix = join("-", compact([for item in local._prefix_token_order : lookup(local._global_prefix_tokens, item, null)]))

  # This overlay now contains the merged result of built-in defaults and user-provided config
  # with some convenience keys for prefixes and uniqueness. We will build all resources from this source of truth
  config_overlay = merge(
    local._decoded_overlay,
    {
      common_config = {
        debug_enabled          = local._decoded_overlay.common_config._debug_enabled
        default_tags           = local._decoded_overlay.common_config.default_tags
        prefix_tokens          = local._decoded_overlay.common_config.prefix_tokens
        resource_prefix        = local._resource_prefix
        global_resource_prefix = local._global_resource_prefix
      },
      stack_id = upper(random_id.shared_resources.hex)
      lut_aws  = local._lut_aws
    },
  )

}
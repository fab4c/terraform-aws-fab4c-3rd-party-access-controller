##############################################################################
# Summary:
#
# This file handles only the differences to internal pattern identity
#
# At a minimum the pattern_id _must_ be unique for each pattern in the catalog
#
##############################################################################

locals {

  # The pattern_id _must_ be unique to all fab4c patterns
  pattern_id = "fab4c_third_party_access_controller"
  # The pattern_type _must_ be one of "units", "fabric", "workloads", "controls", "automation"
  pattern_type = "controls" # tflint-ignore: terraform_unused_declarations

}
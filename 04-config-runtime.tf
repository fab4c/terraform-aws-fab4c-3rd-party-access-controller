##############################################################################
# Summary:
#
# This file handles the dynamic and runtime configuration, some of it
# discovered as data sources, some of it set from overlay and the rest as
# dynamically generated payloads for unit or sub-module usage
#
# This file should contain the majority of the pattern-specific configuration
# differences between multiple patterns
#
##############################################################################


# Extract the AWS Account number
data "aws_caller_identity" "current" {}


# Extract the current AWS region
data "aws_region" "current" {}


# Extract the current AZs
data "aws_availability_zones" "available" {}


# Runtime dynamic data
locals {

  # Our final source of data will be for runtime and dynamic information that
  # needs to be passed from "parent" (root module) to "child" resources (nested submodules)

  dynamic_data = {

    aws_caller_identity    = data.aws_caller_identity.current
    aws_region             = data.aws_region.current
    aws_availability_zones = data.aws_availability_zones.available

  }

}



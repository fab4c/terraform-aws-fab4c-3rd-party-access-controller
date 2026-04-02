
module "fab4c_third_party_access_controller" {

  #checkov:skip=CKV_TF_1:Ignore false positives for URIs that are not Git based.
  # See https://github.com/bridgecrewio/checkov/issues/5366 for more info
  #checkov:skip=CKV_TF_2:Ignore false positive on Terraform Registry modules with pinned version
  # See https://github.com/bridgecrewio/checkov/issues/6335 for more info
  # Normal usage
  source             = "fab4c/fab4c-3rd-party-access-controller/aws"
  version            = "1.5.0"
  configuration_file = "./example.yml"

  # fab4c development usage
  # source             = "../"
  # configuration_file = "./development.yml"

}

# Show important or useful information about the resources managed by this pattern
output "managed_resources" {
  value = module.fab4c_third_party_access_controller.resources
}


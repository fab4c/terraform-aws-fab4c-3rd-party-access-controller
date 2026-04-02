
<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->


# Module Summary

| Property       | Detail                                                                |
| -------------- | --------------------------------------------------------------------- |
| Description    | This Terraform pattern represents a security control that can be used to manage access for 3rd parties to AWS accounts |
| Compatible     | ![badge](https://shields.io/badge/OpenTofu-v1.6+-ffda18?style=flat-square) ![badge](https://shields.io/badge/Terraform-v1.5+-7b42bc?style=flat-square) |
| Support        | Professional Support available. Please see [SUPPORT](SUPPORT.md) for more details |

## Reference Example

```hcl

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

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_file"></a> [configuration\_file](#input\_configuration\_file) | An encoded map payload of configuration attributes in a YAML file | `string` | `"example.yml"` | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resources"></a> [resources](#output\_resources) | n/a |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.1 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |



## How Configuration Works

This module uses a **layered configuration** approach. Rather than defining dozens of individual input variables, all configuration is expressed in a single YAML file that you provide. The module then combines that file with its own built-in defaults and live data discovered from AWS to produce a single, authoritative configuration object that drives every resource it creates.

The diagram below walks through that process step by step.

```mermaid
flowchart TD
    subgraph LAYER1["Layer 1 - Module built-ins"]
        DEFAULTS["Default values"]
        LUT["Lookup tables"]
    end

    subgraph LAYER2["Layer 2 - User Provided"]
        CFGFILE["User YAML config file"]
    end

    subgraph LAYER3["Layer 3 - Discovered at runtime"]
        DS["Live AWS data</br>(account, region, AZs)"]
    end

    subgraph ASSEMBLY["Assembly pipeline  (automatic)"]
        direction TB
        STEP1["<b>1. Scope</b></br>Extract the section</br>for this module"]
        STEP2["<b>2. Feature mask</b></br>Strip settings for</br>disabled features"]
        STEP3["<b>3. Deep merge</b></br>User values override</br> the defaults"]
        STEP4["<b>4. Resource names</b></br>Combine naming tokens</br> with lookup tables"]
        OVERLAY(["Final merged config"])
    end

    subgraph RESOURCES["AWS resources created"]
        RES["Module resources"]
    end

    CFGFILE  --> STEP1
    STEP1    --> STEP2
    STEP2    --> STEP3
    DEFAULTS --> STEP3
    STEP3    --> STEP4
    LUT      --> STEP4
    STEP4    --> OVERLAY

    OVERLAY  --> RES
    DS       --> RES
```

> **Tip — one file, many modules.**  Because the YAML file is keyed by module name at the top level, a single file can hold configuration for several modules side by side. Each module ignores every section that does not belong to it.




<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
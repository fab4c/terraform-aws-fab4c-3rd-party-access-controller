# Each input from the user should be declared here.

# Rather than define 200 separate inputs we will read these from a single user
# provided configuration file or map. Uncomment one of the below.

# File
variable "configuration_file" {
  description = "An encoded map payload of configuration attributes in a YAML file"
  default     = "example.yml"
  type        = string
}

##############################################################################
# This is default entrypoint.
#  - Ensure user provided region is valid
#  - Ensure user provided resource_group is valid
##############################################################################

variable "TF_VERSION" {
 default = "0.13"
 description = "terraform engine version to be used in schematics"
}


variable "generation" {
  default     = 2
  description = "The VPC Generation to target. Valid values are 2 or 1."
}

#provider "ibm" {
  #ibmcloud_api_key      = var.api_key
#  generation            = var.generation
#  region                = var.region
# ibmcloud_timeout      = 300
#}

##############################################################################
# Read/validate Region
##############################################################################
data "ibm_is_region" "region" {
  name = var.region
}


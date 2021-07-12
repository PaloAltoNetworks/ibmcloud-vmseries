terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.27.0"
    }
  }
}

# Configure the IBM Provider
provider "ibm" {
  region           = var.region
  ibmcloud_timeout = 300
  ibmcloud_api_key = var.api_key
  generation       = 2

}
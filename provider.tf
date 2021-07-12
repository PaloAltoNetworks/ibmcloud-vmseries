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
  region           = var.REGION
  ibmcloud_timeout = 300
  ibmcloud_api_key = var.IBMCLOUD_API_KEY
  generation       = 2

}
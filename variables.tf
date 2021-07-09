##############################################################################
# Variable block - See each variable description
##############################################################################

##############################################################################
# vnf_cos_image_url - Vendor provided VM-Series qcow2 Image COS url.
##############################################################################
# variable "vnf_cos_image_url" {
#  description = "The COS image object SQL URL for VM-Series qcow2 image."
#}
##############################################################################
# image_name - The name of the Palo Alto VM-Series (PanOS) image . Valid values are "pa-vm-kvm-9-1-3-1"
##############################################################################
 variable "image_name" {
   default     = "pa-vm-kvm-9-1-3-1"
   description = "The name of the VM-series image to be installed. Valid value is pa-vm-kvm-9-1-3-1"
 }
##############################################################################
# subnet_ids - Subnet where resources are to be provisioned.
##############################################################################
variable "subnet_id1"{
  description =  "The id of the subnet to which VM-Series VSI's first interface(management) belongs to"
}

variable "subnet_id2"{
  description = "The id of the subnet to which VM-Series VSI's second interface(untrust) belongs to"
}

variable "subnet_id3"{
  description = "The id of the subnet to which VM-Series VSI's third interface(trust) belongs to"
}

##############################################################################
# ssh_key_name - The name of the public SSH key to be used when provisining VM-Series VSI.
##############################################################################
variable "ssh_key_name" {
  description = "The name of the public SSH key to be used when provisining VM-Series VSI."
}

##############################################################################
# vnf_vpc_image_name - The name of the VM-Series custom image to be provisioned in your IBM Cloud account.
##############################################################################
# variable "vnf_vpc_image_name" {
#   default     = "vm-series-byol"
#   description = "The name of the VM-Series custom image to be provisioned in your IBM Cloud account (lowercase)"
# }

##############################################################################
# vnf_vpc_image_name - The name of your VM-Series Virtual Server to be provisioned
##############################################################################
variable "vnf_instance_name" {
  default     = "vm-series-byol-vsi"
  description = "The name of your VM-Series Virtual Server to be provisioned."
}

##############################################################################
# vnf_profile - The profile of compute CPU and memory resources to be used when provisioning VM-Series VSI.
##############################################################################
variable "vnf_profile" {
  default     = "bx2-8x32"
  description = "The profile of compute CPU and memory resources to be used when provisioning VM-Series VSI. To list available profiles, run `ibmcloud is instance-profiles`."
}

variable "region" {
  default     = "us-east"
  description = "The region which the VPC instance is located. Options are us-east, us-south, ca-tor, eu-gb, eu-de, eu-fr2, au-syd, jp-osa, jp-tok."
}

#####################################################################################################
# api_key - This is the ibm_cloud_api_key which should be used only while testing this code from CLI. 
# It is not needed while testing from Schematics
######################################################################################################

variable "api_key" {
  description = "Holds the User API key to authenticate with IBM Cloud Account"
}

##############################################################################
# vnf_securtiy_group - The security group to which the first VSI interface(management) belongs to.
##############################################################################
variable "vnf_security_group" {
  description = "The security group to which the first VSI interface(management) belongs to."
}

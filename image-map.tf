##############################################################################
# This file creates custom image using VM-Series qcow2 image hosted in COS
#
##############################################################################


# Generating random ID
resource "random_uuid" "test" { }

#resource "ibm_is_image" "vnf_custom_image" {
 # depends_on       = [random_uuid.test]
 # href             = var.vnf_cos_image_url
 # name             = "${var.vnf_vpc_image_name}-${substr(random_uuid.test.result,0,8)}"
 # operating_system = "ubuntu-18-04-amd64"
 # resource_group = data.ibm_is_subnet.vnf_subnet1.resource_group

 # timeouts {
   # create = "30m"
   # delete = "10m"
#  }
#}


locals {
        image_map = {
	
	pa-vm-kvm-9-1-3-1 = {
    "us-south" = "r006-83c04bd0-f9c4-4e6d-bc0e-5b8618e66968"
		"us-east" = "r014-29b4bed0-9398-4a42-9220-f2cef4f5f39d"
		"eu-gb" = "r018-eefbfc05-af62-4b88-923d-a60eef249ec4"
    "eu-de" = "r010-9899a24b-8d34-43cd-9f85-8d248af4e005"
		"jp-tok" = "r022-e37e9b23-e42c-46e6-a21a-6392c448f834"	
		"eu-fr2" = "r030-c6a4d0ef-e88a-4bfd-a4b4-0835e065cdc7"
    "au-syd" = "r026-8d201ec3-6c48-45c4-9c61-ac1fd7720115"
    "ca-tor" = "r038-01f97815-9b3c-47c5-840c-f50d4ddc8ea5"
    "jp-osa" = "r034-a9430fad-9f49-49a7-ace5-c19db212a24d"
        }        
}
	}

 output "map_instance" {
   value = lookup(local.image_map[var.image_name], data.ibm_is_region.region.name)
}          

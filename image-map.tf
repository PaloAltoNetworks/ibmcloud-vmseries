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
	"ca-tor" = "r038-5492b95e-be77-4c18-84ca-e7c985cbf5f8"
	"jp-osa" = "r034-a9430fad-9f49-49a7-ace5-c19db212a24d"
	"eu-es" = "r050-a46a9b16-60ec-4ec8-ab97-fe20dd0126a7"
        }  
		
		
  pa-vm-kvm-10-0-6 = {
    "us-south" = "r006-a2d7b1fe-feef-45c7-9d43-176899fa699b"
    "us-east" = "r014-7eb6331a-7452-47cf-927f-8a521cf24ed1"
    "jp-tok" = "r022-38517558-8db8-44e3-8447-b17fd4be58c7"
    "jp-osa" = "r034-b6df3c95-4d9f-48d1-b93e-e75cecff8164"
    "eu-gb" = "r018-7541bd69-0342-47db-b878-93d947ce82b7"
    "eu-de" = "r010-e4b9ba8c-b311-4add-a373-74dc6ce69561"
    "ca-tor" = "r038-fcf5a57e-e7e1-475a-923e-3733d462156b"
    "br-sao" = "r042-237b8f2e-7ef4-4260-9678-1b97dbd554e2"
    "au-syd" = "r026-4e5a9dc0-9552-43e3-b748-ef6cca08e11e"
        } 
  }
        }
 output "map_instance" {
   value = lookup(local.image_map[var.image_name], data.ibm_is_region.region.name)
}          

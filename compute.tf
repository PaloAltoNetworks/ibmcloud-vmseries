##############################################################################
# This file creates the compute instance for the Palo Alto Networks VM-Series
##############################################################################

##############################################################################
# Read/validate sshkey
##############################################################################
data "ibm_is_ssh_key" "vnf_ssh_pub_key" {
  name = var.ssh_key_name
}

##############################################################################
# Read/validate vsi profile
##############################################################################
data "ibm_is_instance_profile" "vnf_profile" {
  name = var.vnf_profile
}

##############################################################################
# Create Palo Alto Networks VM-Series VSI.
##############################################################################

//security group
resource "ibm_is_security_group" "vnf_security_group" {
  name           = var.vnf_security_group
  vpc            = data.ibm_is_subnet.vnf_subnet1.vpc
  resource_group = data.ibm_is_subnet.vnf_subnet1.resource_group
}

//security group rule to allow ssh all for management
resource "ibm_is_security_group_rule" "vnf_sg_allow_ssh" {
  depends_on = [ibm_is_security_group.vnf_security_group]
  group     = ibm_is_security_group.vnf_security_group.id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

//security group rule to allow https all for management
resource "ibm_is_security_group_rule" "vnf_sg_rule_in_all" {
  depends_on = [ibm_is_security_group_rule.vnf_sg_allow_ssh]
  group     = ibm_is_security_group.vnf_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

//security group rule to allow all for outbound
resource "ibm_is_security_group_rule" "vnf_sg_rule_out_all" {
  depends_on = [ibm_is_security_group_rule.vnf_sg_rule_in_all]
  group     = ibm_is_security_group.vnf_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

//vnf instance 
resource "ibm_is_instance" "vnf_vsi" {
  depends_on = [ibm_is_security_group_rule.vnf_sg_rule_out_all]
  #name           = "${var.vnf_instance_name}-${substr(random_uuid.test.result,0,8)}"
  name           = var.vnf_instance_name
 # image          = ibm_is_image.vnf_custom_image.id
  image          = lookup(local.image_map[var.image_name], data.ibm_is_region.region.name)
  profile        = data.ibm_is_instance_profile.vnf_profile.name
  resource_group = data.ibm_is_subnet.vnf_subnet1.resource_group

  primary_network_interface {
    name = "eth0"
    subnet = data.ibm_is_subnet.vnf_subnet1.id
    security_groups = [ibm_is_security_group.vnf_security_group.id]
  }
  
  network_interfaces {
    name   = "eth1"
    subnet = data.ibm_is_subnet.vnf_subnet2.id
  }

  network_interfaces {
    name   = "eth2"
    subnet = data.ibm_is_subnet.vnf_subnet3.id
  }

  vpc  = data.ibm_is_subnet.vnf_subnet1.vpc
  zone = data.ibm_is_subnet.vnf_subnet1.zone
  keys = [data.ibm_is_ssh_key.vnf_ssh_pub_key.id]

  //User can configure timeouts
  timeouts {
    create = "30m"
    delete = "30m"
  }
  # Handling race condition; Required by Terraform IBM provider.
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

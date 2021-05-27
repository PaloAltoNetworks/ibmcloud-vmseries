# VM-Series Next-Generation Firewall (BYOL) on IBM Cloud VPC (Standalone; High Resiliency (Active/Active) planned)

IBM Cloud is an important deployment platform for your business-critical applications. Protecting the increased public cloud footprint from threats, data loss, and business disruption remains challenging. The VM-Series Virtual Next-Generation Firewall (NGFW) on IBM Cloud solves these challenges, enabling you to:
Protect your workloads through unmatched application visibility and precise control.
Prevent threats from moving laterally between workloads and stop data exfiltration.
Eliminate security-induced application development bottlenecks with automation and centralized management.

Palo Alto Networks VM-Series virtual NGFWs protect your IBM Cloud workloads with next-generation security features that allow you to confidently and quickly migrate your business-critical applications to the cloud. Embed the VM-Series in your automated infrastructure provisioning workflows to prevent data loss and business disruption in even the most dynamic environments.

https://www.paloaltonetworks.com


## Version
PAN-OS 9.1.3
Follow the standard upgrade process after the VM-series in installed if a newer release is required.

 https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/about-the-vm-series-firewall/upgrade-the-vm-series-firewall/upgrade-the-vm-series-model.html


## License Requirements
The VM-Series on IBM Cloud supports bring-your-own-license (BYOL) as a licensing model. You can purchase your VM-Series license through normal Palo Alto Networks channels, and then deploy the VM-Series using the license authorization code you received. 
https://docs.paloaltonetworks.com/vm-series/10-0/vm-series-deployment/license-the-vm-series-firewall/vm-series-models/license-typesvm-series-firewalls

https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/license-the-vm-series-firewall.html

## Prerequisites
- Have access to [IBM Cloud Gen 2 VPC](https://cloud.ibm.com/vpc-ext/).
- A VPC with at least three subnets and one IP address unassigned in each subnet - the VM-Series VSI will be assigned the IP Addresses in its interfaces from the user provided subnets as the input. [Reference](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-a-vpc-using-the-ibm-cloud-console#creating-a-vpc-and-subnet)
- Identify region to install PAN-OS
    - us-east
    - us-south
    - ca-tor
    - eu-gb
    - eu-de
    - eu-fr2
    - au-syd
    - jp-osa
    - jp-tok
    
## Dependencies

Before you can apply the template in IBM Cloud, complete the following steps.


1.  Ensure that you have the following permissions in IBM Cloud Identity and Access Management:
    * `Manager` service access role for IBM Cloud Schematics
    * `Operator` platform role for VPC Infrastructure
2.  Ensure the following resources exist in your VPC Gen 2 environment
    - VPC ()
    - SSH Key: [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys)
    - VPC has 3 subnets
    - Floating IP (FIP) Address to assign to the management interface of VM-Series instance post deployment. FIP is used to access your VPC virtual server instance over the public internet. https://cloud.ibm.com/docs/vpc?topic=vpc-creating-a-vpc-using-the-rest-apis#create-floating-ip-api-tutorial


### Required Parameters for Deployment
Fill in the following values, based on the steps that you completed before you began.

| Key | Definition | Value Example |
| --- | ---------- | ------------- |  
| `region` | The VPC region that you want your VPC virtual servers to be provisioned. | "us-east us-south ca-tor eu-gb eu-de eu-fr2 au-syd jp-osa jp-tok" |
| `vnf_profile` | The profile of compute CPU and memory resources to be used when provisioning the vnf instance. To list available profiles, run `ibmcloud is instance-profiles`or https://cloud.ibm.com/docs/vpc?topic=vpc-profiles. | "bx2-8x32" |
| `subnet_id1` | The ID of the subnet(management) which will be associated with first interface of the VNF instance. Click on the subnet details in the VPC Subnet Listing to determine this value | "0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx" |
| `subnet_id2` | The ID of the subnet(untrust) which will be associated with second interface of the VNF instance. Click on the subnet details in the VPC Subnet Listing to determine this value | "0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx" |
| `subnet_id3` | The ID of the subnet(trust) which will be associated with third interface of the VNF instance. Click on the subnet details in the VPC Subnet Listing to determine this value | "0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx" |
| `vnf_security_group` | The name of the security group to which the VNF Instance's first interface(management) belong to | "vm-series-mgmt-sg" |
| `vnf_instance_name` | The name of the VNF instance to be provisioned (lower-case). | "vm-series-fw-vsi" |
| `ssh_key_name` | The name of your public SSH key to be used for VSI. Follow [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing ssh key. | "vm-series-ssh-key" |


## Notes

If there is any failure during VSI creation, the created resources must be destroyed before attempting to instantiate again. 
- If you are using IBM Cloud Schematics: 
    - To destroy resources go to `Schematics -> Workspaces -> [Your Workspace] -> Actions -> Delete` to delete  all associated resources.
- If you are using Terraform CLI:
    - Execute `terraform destroy --auto-approve` 

# Post VM-Series VSI Instance Spin-up

1. From the VPC list, confirm the VM-Series VSI is powered ON with green button
2. Assign a Floating IP to the VM-Series VSI. Refer the steps below to associate floating IP
    - Go to `VPC Infrastructure Gen 2` from IBM Cloud
    - Click `Floating IPs` from the left pane
    - Click `Reserve floating IP` -> Click `Reserve IP`
    - There will be a (new) Floating IP address with status `Unbind`
    - Click Three Dot Button corresponding to the Unbound IP address -> Click `Bind`
    - Select VM-Series instance (eth0) from `Instance to bind` column.
    - After clicking `Bind`, you can see the IP address assigned to your VM-Series-VSI Instance.
3. Wait for VM-Series VSI to boot up.
4. Connect via web browser GUI, https://floatingIPaddress or from the CLI, run `ssh -i private_key.pem admin@<Floating IP>`.

Note: Default credentials are "admin":"admin" when using the VM-Series image. After the first login, you will be prompted to change your password for security reasons. PLEASE CHANGE DEFAULT LOGIN CREDENTIALS

## Support Policy
The code and script in the repo are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts are still supported, but the support is only for the product functionality and not for help in deploying or using the script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.

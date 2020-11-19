# Deploy VM-Series VSI on IBM Cloud

This directory contains the terraform code to create a VM-Series Instance with three network interfaces(management, trust, untrust).
  
Use this template to create VM-Series virtual instance using qcow2 image from your IBM Cloud account in IBM Cloud [VPC Gen2](https://cloud.ibm.com/vpc-ext/overview) by using Terraform or IBM Cloud Schematics.  Schematics uses Terraform as the infrastructure-as-code engine.  With this template, you can create and manage infrastructure as a single unit as follows. For more information about how to use this template, see the IBM Cloud [Schematics documentation](https://cloud.ibm.com/docs/schematics).

## Deployment Options

Note : 
    - You can either run the code using your own Terraform CLI or use the IBM Cloud Schematics Workspace which can run Terraform for you.
    - (Option 1) IBM Cloud Schematics: Create a schematics workspace and provide the github repository url (https://github.com/PaloAltoNetworks/ibmcloud) under settings to pull the latest code, so that you can set up your deployment variables from the `Create` page. Once the template is applied, IBM Cloud Schematics  provisions the resources based on the values that were specified for the deployment variables.
    - (Option 2) Terraform CLI v0.12.x:
        - [Setting up Terraform CLI and the IBM Cloud Provider Plug-in](https://cloud.ibm.com/docs/terraform?topic=terraform-tf-provider)
        - You should update the parameters in the terraform.tfvars file.
        - Execcute the following
        
        `terraform init`
        
        `terraform apply --auto-approve`

## Prerequisites
- Have access to [IBM Cloud Gen 2 VPC](https://cloud.ibm.com/vpc-ext/).
- A VPC with at least three subnets and one IP address unassigned in each subnet - the VM-Series VSI will be assigned the IP Addresses in its interfaces from the user provided subnets as the input. [Reference](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-a-vpc-using-the-ibm-cloud-console#creating-a-vpc-and-subnet)
- Setup the VM-Series image in Cloud Object Storage:
    - Create a **Publicly Accessible** Cloud Object Storage (COS) Bucket and upload the qcow2 image using the methods described in _IBM COS getting started docs_ (https://test.cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started). This qcow2 image will be used to create a custom image (https://cloud.ibm.com/docs/vpc?topic=vpc-managing-images) in your IBM Cloud account by the terraform script. It's recommended to delete the custom image after the VNF is created by terraform.
    - Copy the VM-Series qcow2 image to the COS bucket to install and create a VSI. 
    - Create a **READ ALL** permissions on the relevant bucket containing the qcow2 image using the method provided here (https://cloud.ibm.com/docs/cloud-object-storage/iam?topic=cloud-object-storage-iam-public-access#public-access-object). Here is an example for us-south region using the IBM Cloud CLI (https://cloud.ibm.com/docs/cli?topic=cli-getting-started):

  <pre><code>$ export token=`ibmcloud iam oauth-tokens | awk '{ print $4 }'`
  $ curl -v -X "PUT" "https://s3.us-south.cloud-object-storage.appdomain.cloud/vendorbucketname/vendor.qcow2?acl" -H "Authorization: Bearer $token" -H "x-amz-acl: public-read"</code></pre>

## Dependencies

Before you can apply the template in IBM Cloud, complete the following steps.


1.  Ensure that you have the following permissions in IBM Cloud Identity and Access Management:
    * `Manager` service access role for IBM Cloud Schematics
    * `Operator` platform role for VPC Infrastructure
2.  Ensure the following resources exist in your VPC Gen 2 environment
    - VPC ()
    - SSH Key: [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys)
    - VPC has 3 subnets
    - _(Optional):_ A Floating IP Address to assign to the management interface of VM-Series instance post deployment


### Required Parameters for Deployment
Fill in the following values, based on the steps that you completed before you began.

| Key | Definition | Value Example |
| --- | ---------- | ------------- | 
| `api_key` | API Key to authorize access to your IBM Cloud account. [Create an API Key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)  | "xxxxx0000xxxxx" | 
| `region` | The VPC region that you want your VPC virtual servers to be provisioned. | "us-south" |
| `vnf_cos_image_url` | This is the vendor COS image SQL URL where the image(VM-Series qcow2 image) is located. This is to copy the image from COS to VPC custom image in your IBM Cloud account VPC Infrastructure. First time, the image needs to be copied to your VPC cloud account. | "cos://us-east/palo-alto/PA-VM-KVM-10.0.1.qcow2" |
| `vnf_profile` | The profile of compute CPU and memory resources to be used when provisioning the vnf instance. To list available profiles, run `ibmcloud is instance-profiles`. | "bx2-8x32" |
| `subnet_id1` | The ID of the subnet(management) which will be associated with first interface of the VNF instance. Click on the subnet details in the VPC Subnet Listing to determine this value | "0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx" |
| `subnet_id2` | The ID of the subnet(untrust) which will be associated with second interface of the VNF instance. Click on the subnet details in the VPC Subnet Listing to determine this value | "0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx" |
| `subnet_id3` | The ID of the subnet(trust) which will be associated with third interface of the VNF instance. Click on the subnet details in the VPC Subnet Listing to determine this value | "0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx" |
| `vnf_security_group` | The name of the security group to which the VNF Instance's first interface(management) belong to | "vm-series-mgmt-sg" |
| `vnf_vpc_image_name` | The starting name of the VM-Series qcow2 Custom Image to be provisioned in your IBM Cloud account and (if already available) to be used to create the VM-Series virtual server instance. The name is appended with UUID, to create a unique custom image for every run. | "vm-series-fw-image" |
| `vnf_instance_name` | The name of the VNF instance to be provisioned. | "vm-series-fw-vsi" |
| `ssh_key_name` | The name of your public SSH key to be used for VSI. Follow [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing ssh key. | "vm-series-ssh-key" |


## Notes

If there is any failure during VSI creation, the created resources must be destroyed before attempting to instantiate again. 
    - If you are using IBM Cloud Schematics: 
        - To destroy resources go to `Schematics -> Workspaces -> [Your Workspace] -> Actions -> Delete` to delete  all associated resources. <br/>
    - If you are using Terraform CLI:
        - Execute `terraform destroy --auto-approve` 

# Post VM-Series VSI Instance Spin-up (Optional)

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
4. From the CLI, run `ssh -i private_key.pem admin@<Floating IP>`.

Note: Default credentials are "admin":"admin" when using the VM-Series qcow2 image. After the first login, you will be prompted to change your password for security reasons.

## Support Policy
The code and script in the repo are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts are still supported, but the support is only for the product functionality and not for help in deploying or using the script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.

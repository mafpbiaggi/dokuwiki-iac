module "oci_production" {
  # -----------------------------------------------------------
  # General denifitions
  # -----------------------------------------------------------
  source       = "../../"
  region       = "{{ secrets.REGION }}"
  tenancy_ocid = "{{ secrets.TENANCY_OCID }}"

  # -----------------------------------------------------------
  # Compartment definitions
  # -----------------------------------------------------------
  compartment_description = "Compartment for production applications."
  compartment_name        = "{{ secrets.COMPARTMENT_NAME }}"

  # -----------------------------------------------------------
  # Network definitions
  # -----------------------------------------------------------
  vcn_cidr_blocks          = ["{{ secrets.VNC_CIDR_BLOCKS }}"]
  vcn_display_name         = "{{ secrets.VNC_DISPLAY_NAME }}"
  vcn_dns_label            = "{{ secrets.VCN_DNS_LABEL }}"
  public_subnet_cidr_block = "{{ secrets.PUBLIC_SUBNET_CIDR_BLOCK }}"

  # -----------------------------------------------------------
  # Security definitions
  # -----------------------------------------------------------
  http_port  = "{{ secrets.HTTP_PORT }}"
  https_port = "{{ secrets.HTTPS_PORT }}"

  # -----------------------------------------------------------
  # Bucket definitions
  # -----------------------------------------------------------
  bucket_name         = "{{ secrets.BUCKET_NAME }}"
  bucket_access_type  = "NoPublicAccess"
  bucket_storage_tier = "Standard"

  # -----------------------------------------------------------
  # Instance definitions
  # -----------------------------------------------------------
  instance_availability_domain = "{{ secrets.INSTANCE_AVAILABILITY_DOMAIN }}"
  instance_shape               = "{{ secrets.INSTANCE_SHAPE }}"
  operating_system             = "{{ secrets.OPERATING_SYSTEM }}"
  operating_system_version     = "{{ secrets.OPERATING_SYSTEM_VERSION }}"

  ssh_public_key = "{{  secrets.SSH_PUBLIC_KEY }}"

  instance_create_vnic_details_hostname_label = "{{  secrets.INSTANCE_CREATE_VNIC_DETAILS_HOSTNAME_LABEL }}"
  instance_display_name                       = "{{  secrets.INSTANCE_DISPLAY_NAME }}"
}

# -----------------------------------------------------------
# Output definitions
# -----------------------------------------------------------
output "compartment_name" {
  value = module.oci_production._compartment_name
}

output "compartment_id" {
  value = module.oci_production._compartment_id
}

output "bucket_id" {
  value = module.oci_production._bucket_id
}

output "instance_public_ip" {
  value = module.oci_production._public_ip
}

output "instance_private_ip" {
  value = module.oci_production._private_ip
}

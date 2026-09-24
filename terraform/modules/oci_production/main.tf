module "oci_production" {
  # -----------------------------------------------------------
  # General denifitions
  # -----------------------------------------------------------
  source       = "../../"
  region       = "$REGION"
  tenancy_ocid = "$TENANCY_OCID"

  # -----------------------------------------------------------
  # Compartment definitions
  # -----------------------------------------------------------
  compartment_description = "Compartment for production applications."
  compartment_name        = "$COMPARTMENT_NAME"

  # -----------------------------------------------------------
  # Network definitions
  # -----------------------------------------------------------
  vcn_cidr_blocks          = "$VNC_CIDR_BLOCKS"
  vcn_display_name         = "$VNC_DISPLAY_NAME"
  vcn_dns_label            = "$VCN_DNS_LABEL"
  public_subnet_cidr_block = "$PUBLIC_SUBNET_CIDR_BLOCK"

  # -----------------------------------------------------------
  # Security definitions
  # -----------------------------------------------------------
  http_port  = "$HTTP_PORT"
  https_port = "$HTTPS_PORT"

  # -----------------------------------------------------------
  # Bucket definitions
  # -----------------------------------------------------------
  bucket_name         = "$BUCKET_NAME"
  bucket_access_type  = "NoPublicAccess"
  bucket_storage_tier = "Standard"

  # -----------------------------------------------------------
  # Instance definitions
  # -----------------------------------------------------------
  instance_availability_domain = "$INSTANCE_AVAILABILITY_DOMAIN"
  instance_shape               = "$INSTANCE_SHAPE"
  operating_system             = "$OPERATING_SYSTEM"
  operating_system_version     = "$OPERATING_SYSTEM_VERSION"

  ssh_public_key = "$SSH_PUBLIC_KEY"

  instance_create_vnic_details_hostname_label = "$INSTANCE_CREATE_VNIC_DETAILS_HOSTNAME_LABEL"
  instance_display_name                       = "$INSTANCE_DISPLAY_NAME"
}

# -----------------------------------------------------------
# Output definitions
# -----------------------------------------------------------
output "instance_public_ip" {
  value = module.oci_production._public_ip
}

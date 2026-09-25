module "oci_production" {
  source = "./modules/oci_production"

  # -----------------------------------------------------------
  # Compartment
  # -----------------------------------------------------------
  tenancy_ocid            = var.tenancy_ocid
  compartment_name        = var.compartment_name
  compartment_description = var.compartment_description

  # -----------------------------------------------------------
  # Network
  # -----------------------------------------------------------
  vcn_cidr_blocks          = var.vcn_cidr_blocks
  vcn_display_name         = var.vcn_display_name
  vcn_dns_label            = var.vcn_dns_label
  public_subnet_cidr_block = var.public_subnet_cidr_block

  # -----------------------------------------------------------
  # Security
  # -----------------------------------------------------------
  http_port  = var.http_port
  https_port = var.https_port

  # -----------------------------------------------------------
  # Storage
  # -----------------------------------------------------------
  bucket_name         = var.bucket_name
  bucket_access_type  = var.bucket_access_type
  bucket_storage_tier = var.bucket_storage_tier

  # -----------------------------------------------------------
  # Compute
  # -----------------------------------------------------------
  instance_availability_domain                = var.instance_availability_domain
  instance_shape                              = var.instance_shape
  instance_display_name                       = var.instance_display_name
  instance_create_vnic_details_hostname_label = var.instance_create_vnic_details_hostname_label
  operating_system                            = var.operating_system
  operating_system_version                    = var.operating_system_version
  ssh_public_key                              = var.ssh_public_key
}

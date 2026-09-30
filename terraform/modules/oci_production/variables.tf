# -----------------------------------------------------------
# Compartment
# -----------------------------------------------------------
variable "tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "compartment_name" {
  type = string
}

variable "compartment_description" {
  type    = string
  default = "Compartment for production applications"
}

# -----------------------------------------------------------
# Network
# -----------------------------------------------------------
variable "vcn_cidr_blocks" {
  type = list(string)
}

variable "vcn_display_name" {
  type = string
}

variable "vcn_dns_label" {
  type = string
}

variable "public_subnet_cidr_block" {
  type = string
}

# -----------------------------------------------------------
# Security
# -----------------------------------------------------------
variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

# -----------------------------------------------------------
# Storage
# -----------------------------------------------------------
variable "bucket_name" {
  type = string
}

variable "bucket_access_type" {
  type    = string
  default = "NoPublicAccess"
}

variable "bucket_storage_tier" {
  type    = string
  default = "Standard"
}

variable "bucket_object_events_enabled" {
  type    = bool
  default = true
}

variable "bucket_versioning" {
  type    = string
  default = "Enabled"
}

# -----------------------------------------------------------
# Compute
# -----------------------------------------------------------
variable "instance_availability_domain" {
  type = string
}

variable "instance_shape" {
  type = string
}

variable "instance_display_name" {
  type = string
}

variable "instance_create_vnic_details_hostname_label" {
  type = string
}

variable "instance_instance_options_are_legacy_imds_endpoints_disabled" {
  type    = bool
  default = true
}

variable "instance_is_pv_encryption_in_transit_enabled" {
  type    = bool
  default = true
}

variable "operating_system" {
  type = string
}

variable "operating_system_version" {
  type = string
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}

# -----------------------------------------------------------
# General variables
# -----------------------------------------------------------
variable "region" {
  type    = string
  default = "sa-saopaulo-1"
  sensitive = true
}

# -----------------------------------------------------------
# Compartment variables
# -----------------------------------------------------------
variable "tenancy_ocid" {
  type    = string
  sensitive = true
}

variable "compartment_description" {
  type = string
  sensitive = true
}

variable "compartment_name" {
  type = string
  sensitive = true
}

# -----------------------------------------------------------
# Network variables
# -------------------------------------------------------
variable "vcn_cidr_blocks" {
  type = list
  sensitive = true
}

variable "vcn_display_name" {
  type = string
  sensitive = true
}

variable "vcn_dns_label" {
  type = string
  sensitive = true
}

variable "public_subnet_cidr_block" {
  type = string
  sensitive = true
}

# -----------------------------------------------------------
# Security variables
# -----------------------------------------------------------
variable "http_port" {
  type = string
  sensitive = true
}

variable "https_port" {
  type = string
  sensitive = true
}

# -----------------------------------------------------------
# Bucket variables
# -----------------------------------------------------------
variable "bucket_name" {
  type = string
  sensitive = true
}

variable "bucket_access_type" {
  type = string
}

variable "bucket_storage_tier" {
  type = string
}

# -----------------------------------------------------------
# Instance variables
# -----------------------------------------------------------
variable "instance_availability_domain" {
  type = string
  sensitive = true
}

variable "instance_shape" {
  type = string
  sensitive = true
}

variable "operating_system" {
  type = string
  sensitive = true
}

variable "operating_system_version" {
  type = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
  sensitive = true
}

variable "instance_create_vnic_details_hostname_label" {
  type = string
  sensitive = true
}

variable "instance_display_name" {
  type = string
  sensitive = true
}

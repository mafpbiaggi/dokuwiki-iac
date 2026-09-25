resource "oci_core_vcn" "this" {
  compartment_id = oci_identity_compartment.this.id
  cidr_blocks    = var.vcn_cidr_blocks
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_subnet" "public" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id
  cidr_block     = var.public_subnet_cidr_block
  dns_label      = "pub"
  route_table_id = oci_core_default_route_table.this.id
  security_list_ids = [
    data.oci_core_security_lists.this.security_lists[0].id,
    oci_core_security_list.this.id
  ]
}

resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id
  display_name               = "default route table for ${var.vcn_display_name}"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id
  enabled        = true
  display_name   = "internet gateway for ${var.vcn_display_name}"
}

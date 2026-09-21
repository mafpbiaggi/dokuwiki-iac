resource "oci_identity_compartment" "this" {
	compartment_id = var.tenancy_ocid
	description = var.compartment_description
	name = var.compartment_name
}

output "compartment_name" {
	value = oci_identity_compartment.this.name
}

output "compartment_id" {
	value = oci_identity_compartment.this.id
}

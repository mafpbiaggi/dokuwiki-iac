data "oci_objectstorage_namespace" "this" {
  compartment_id = var.tenancy_ocid
}

resource "oci_objectstorage_bucket" "this" {
  compartment_id = oci_identity_compartment.this.id
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = var.bucket_name
  access_type    = var.bucket_access_type
  storage_tier   = var.bucket_storage_tier
}

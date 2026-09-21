data "oci_core_images" "this" {
  compartment_id           = var.tenancy_ocid
  operating_system         = var.operating_system
  operating_system_version = var.operating_system_version
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "this" {
  availability_domain = var.instance_availability_domain
  compartment_id      = oci_identity_compartment.this.id
  shape               = var.instance_shape
  display_name        = var.instance_display_name
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  create_vnic_details {
    assign_public_ip = true
    hostname_label   = var.instance_create_vnic_details_hostname_label
    subnet_id        = oci_core_subnet.public.id
  }

  source_details {
    source_id   = data.oci_core_images.this.images[0].id
    source_type = "image"
  }
}

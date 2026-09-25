data "oci_core_security_lists" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "Default Security List for ${var.vcn_display_name}"
}

resource "oci_core_security_list" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "Web Access Security List for ${var.vcn_display_name}"

  ingress_security_rules { # Allows access over HTTP
    protocol = "6"         # TCP
    source   = "0.0.0.0/0"

    tcp_options {
      max = var.http_port
      min = var.http_port
    }
  }

  ingress_security_rules { # Allows access over HTTPS
    protocol = "6"         # TCP
    source   = "0.0.0.0/0"

    tcp_options {
      max = var.https_port
      min = var.https_port
    }
  }
}

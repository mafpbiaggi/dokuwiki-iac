terraform {
  backend "oci" {
    bucket    = "bt-terraform"
    key       = "oci_production/terraform.tfstate"
    region    = "{{ secrets.REGION }}"
    namespace = "{{ secrets.OS_NAMESPACE }}"
  }
}

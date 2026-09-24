terraform {
  backend "oci" {
    bucket    = "bt-terraform"
    key       = "oci_production/terraform.tfstate"
    region    = "$REGION"
    namespace = "$OS_NAMESPACE"
  }
}

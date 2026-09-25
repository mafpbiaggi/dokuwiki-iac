# -----------------------------------------------------------
# General
# -----------------------------------------------------------
variable "region" {
  type        = string
  description = "Região OCI onde os recursos serão provisionados."
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID do tenancy OCI."
  sensitive   = true
}

variable "user_ocid" {
  type        = string
  description = "OCID do usuário/IAM usado pela API Key."
  sensitive   = true
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint da API Key do usuário OCI."
  sensitive   = true
}

variable "private_key" {
  type        = string
  description = "Conteúdo da chave privada da API Key OCI (PEM)."
  sensitive   = true
}

variable "private_key_password" {
  type        = string
  description = "Senha da chave privada da API Key OCI (PEM)."
  sensitive   = true
}

# -----------------------------------------------------------
# Compartment
# -----------------------------------------------------------
variable "compartment_name" {
  type        = string
  description = "Nome do compartment de produção."
}

variable "compartment_description" {
  type        = string
  description = "Descrição do compartment de produção."
  default = "Compartment for applications"
}

# -----------------------------------------------------------
# Network
# -----------------------------------------------------------
variable "vcn_cidr_blocks" {
  type        = list(string)
  description = "Lista de blocos CIDR da VCN."
}

variable "vcn_display_name" {
  type        = string
  description = "Nome de exibição da VCN."
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label da VCN."
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "Bloco CIDR da subnet pública."
}

# -----------------------------------------------------------
# Security
# -----------------------------------------------------------
variable "http_port" {
  type        = number
  description = "Porta HTTP liberada na security list."
  default     = 80
}

variable "https_port" {
  type        = number
  description = "Porta HTTPS liberada na security list."
  default     = 443
}

# -----------------------------------------------------------
# Storage
# -----------------------------------------------------------
variable "bucket_name" {
  type        = string
  description = "Nome do bucket de Object Storage."
}

variable "bucket_access_type" {
  type        = string
  description = "Tipo de acesso do bucket (ex.: NoPublicAccess, ObjectRead)."
  default     = "NoPublicAccess"
}

variable "bucket_storage_tier" {
  type        = string
  description = "Tier de armazenamento do bucket (Standard ou Archive)."
  default     = "Standard"
}

# -----------------------------------------------------------
# Compute
# -----------------------------------------------------------
variable "instance_availability_domain" {
  type        = string
  description = "Availability domain da instância."
}

variable "instance_shape" {
  type        = string
  description = "Shape da instância compute."
}

variable "instance_display_name" {
  type        = string
  description = "Nome de exibição da instância."
}

variable "instance_create_vnic_details_hostname_label" {
  type        = string
  description = "Hostname label da VNIC da instância."
}

variable "operating_system" {
  type        = string
  description = "Sistema operacional da imagem (ex.: Canonical Ubuntu)."
}

variable "operating_system_version" {
  type        = string
  description = "Versão do sistema operacional da imagem."
}

variable "ssh_public_key" {
  type        = string
  description = "Chave pública SSH autorizada na instância."
  sensitive   = true
}

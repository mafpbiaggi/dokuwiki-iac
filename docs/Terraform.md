# Terraform - Oracle Cloud Infrastructure

Este diretório provisiona a infraestrutura necessária para executar o Dokuwiki na Oracle Cloud Infrastructure (OCI) usando Terraform.

> **ATENÇÃO**: antes de utilizar este material, consulte a [documentação oficial do provider OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs) e a documentação do [OCI CLI](https://docs.oracle.com/pt-br/iaas/Content/API/Concepts/cliconcepts.htm).

## Estrutura do diretório

```text
terraform/
├── backend.tf              # backend OCI do Terraform
├── main.tf                 # instancia o módulo oci_production
├── outputs.tf              # exporta saída do módulo
├── providers.tf            # provider OCI e versionamento
├── variables.tf            # variáveis do projeto raiz
└── modules/
    └── oci_production/
        ├── compartment.tf     # compartment da aplicação
        ├── compute.tf         # instância OCI
        ├── network.tf         # VCN, subnet, gateway e rota
        ├── outputs.tf         # saída pública da instância
        ├── security.tf        # security list com HTTP/HTTPS
        ├── storage.tf         # bucket de Object Storage
        ├── variables.tf       # variáveis do módulo
        └── versions.tf        # versionamento do provider
```

## O que esse Terraform provisiona

O módulo `oci_production` cria os recursos abaixo:

- `oci_identity_compartment.this`: compartment para a aplicação
- `oci_core_vcn.this`: VCN da infraestrutura
- `oci_core_subnet.public`: subnet pública
- `oci_core_internet_gateway.this`: gateway de internet
- `oci_core_default_route_table.this`: rota padrão para internet
- `oci_core_security_list.this`: regras de acesso HTTP e HTTPS
- `oci_objectstorage_bucket.this`: bucket de Object Storage
- `oci_core_instance.this`: instância compute com IP público e chave SSH autorizada

A saída principal do root module é `oci_production_public_ip`, exportada em [terraform/outputs.tf](../terraform/outputs.tf).

## Requisitos para execução

- Conta e tenancy na Oracle Cloud Infrastructure (OCI)
- Usuário IAM com permissão para criar recursos
- Chave API OCI configurada
- Terraform version `>= 1.6.0`
- Provider `oracle/oci` com versão aproximada a `~> 9.3`

## Variáveis esperadas

As variáveis definidas no root module estão em [terraform/variables.tf](../terraform/variables.tf) e o módulo filho em [terraform/modules/oci_production/variables.tf](../terraform/modules/oci_production/variables.tf).

### Obrigatórias

- `region`
- `tenancy_ocid`
- `user_ocid`
- `fingerprint`
- `private_key`
- `private_key_password`
- `compartment_name`
- `vcn_cidr_blocks`
- `vcn_display_name`
- `vcn_dns_label`
- `public_subnet_cidr_block`
- `bucket_name`
- `instance_availability_domain`
- `instance_shape`
- `instance_display_name`
- `instance_create_vnic_details_hostname_label`
- `operating_system`
- `operating_system_version`
- `ssh_public_key`

### Opcionais com valor padrão

- `compartment_description` = `Compartment for applications`
- `http_port` = `80`
- `https_port` = `443`
- `bucket_access_type` = `NoPublicAccess`
- `bucket_storage_tier` = `Standard`

## Arquivo de ambiente de exemplo

O exemplo de variáveis pode ser consultado em [docs/samples/.env.example](samples/.env.example). Esse arquivo usa o padrão do Terraform para leitura automática de variáveis do ambiente, com prefixo `TF_VAR_`:

```bash
TF_VAR_region="sa-saopaulo-1"
TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaa..."
TF_VAR_user_ocid="ocid1.user.oc1..aaaa..."
TF_VAR_fingerprint="AA:BB:CC:..."
TF_VAR_private_key="-----BEGIN ENCRYPTED PRIVATE KEY-----<conteudo-da-chave>-----END ENCRYPTED PRIVATE KEY-----OCI_API_KEY"
TF_VAR_private_key_password="Yxirom3TXF4wNUK"
TF_VAR_compartment_name="dokuwiki-prod"
TF_VAR_vcn_cidr_blocks='["10.0.0.0/16"]'
TF_VAR_vcn_display_name="dokuwiki-vcn"
TF_VAR_vcn_dns_label="dokuwiki"
TF_VAR_public_subnet_cidr_block="10.0.0.0/24"
TF_VAR_bucket_name="dokuwiki-bucket"
TF_VAR_instance_availability_domain="..."
TF_VAR_instance_shape="VM.Standard.E4.Flex"
TF_VAR_instance_display_name="dokuwiki-instance"
TF_VAR_instance_create_vnic_details_hostname_label="dokuwiki"
TF_VAR_operating_system="Canonical Ubuntu"
TF_VAR_operating_system_version="24.04"
TF_VAR_ssh_public_key="ssh-rsa AAAA..."
```

## Execução local

A execução local deve ser feita a partir do diretório `terraform/`.

### 1) Preparar o ambiente

```bash
cd terraform
set -a
source /caminho/para/.env
set +a
```

> O arquivo `.env` deve conter as variáveis com prefixo `TF_VAR_` para que o Terraform as reconheça automaticamente.

### 2) Inicializar o backend e o provider

Quando o backend OCI é usado, o bucket do backend precisa existir antes do `terraform init`:

```bash
export TF_VAR_namespace="$(oci os ns get --query 'data' --raw-output)"
export TF_VAR_backend_bucket="bucket-terraform"
export TF_VAR_backend_key="dokuwiki/terraform.tfstate"

oci os bucket create \
  --compartment-id "$TF_VAR_tenancy_ocid" \
  --name "$TF_VAR_backend_bucket" \
  --namespace-name "$TF_VAR_namespace" \
  --region "$TF_VAR_region" \
  --public-access-type NoPublicAccess \
  --storage-tier Standard
```

Em seguida:

```bash
cd terraform

terraform init \
  -backend-config="bucket=$TF_VAR_backend_bucket" \
  -backend-config="key=$TF_VAR_backend_key" \
  -backend-config="region=$TF_VAR_region" \
  -backend-config="namespace=$TF_VAR_namespace" \
  -backend-config="private_key=$TF_VAR_private_key" \
  -backend-config="private_key_password=$TF_VAR_private_key_password" \
  -reconfigure
```

### 3) Validar e aplicar

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

Para destruir os recursos:

```bash
terraform destroy
```

## Execução pelo GitHub Actions

O workflow [infra-provision.yml](../.github/workflows/infra-provision.yml) executa `terraform plan`, `terraform init`, `terraform validate` e `terraform apply` no diretório `terraform/`. Ele pode ser iniciado manualmente ou chamado por outro workflow reutilizável.

Antes da execução, cadastre os valores abaixo em **Settings > Secrets and variables > Actions > Secrets** do repositório. O workflow lê todos pelo contexto `secrets` e os disponibiliza ao Terraform com o prefixo `TF_VAR_`:

```text
BACKEND_BUCKET
BACKEND_KEY
NAMESPACE
REGION
TENANCY_OCID
USER_OCID
FINGERPRINT
PRIVATE_KEY
PRIVATE_KEY_PASSWORD
COMPARTMENT_NAME
VCN_CIDR_BLOCKS
VCN_DISPLAY_NAME
VCN_DNS_LABEL
PUBLIC_SUBNET_CIDR_BLOCK
HTTP_PORT
HTTPS_PORT
BUCKET_NAME
INSTANCE_AVAILABILITY_DOMAIN
INSTANCE_SHAPE
INSTANCE_DISPLAY_NAME
INSTANCE_CREATE_VNIC_DETAILS_HOSTNAME_LABEL
OPERATING_SYSTEM
OPERATING_SYSTEM_VERSION
SSH_PUBLIC_KEY
```

Informe `PRIVATE_KEY` com o conteúdo PEM da chave privada OCI, não com o caminho para um arquivo. `PRIVATE_KEY_PASSWORD` deve conter a senha da chave ou ficar vazio se ela não tiver senha. `VCN_CIDR_BLOCKS` deve ser uma lista JSON, por exemplo ` ["10.0.0.0/16"] `; informe também `HTTP_PORT` e `HTTPS_PORT` como números, por exemplo `80` e `443`. Como o workflow define esses valores explicitamente, configure-os mesmo que o Terraform tenha valores padrão para as portas.

O bucket de backend indicado por `BACKEND_BUCKET` precisa existir antes de iniciar o workflow. `BACKEND_KEY` identifica o arquivo de state e `NAMESPACE` é o namespace do Object Storage OCI.

Para executar manualmente, abra a aba **Actions**, selecione **Infra Provision**, clique em **Run workflow** e confirme a branch. Para a execução reutilizável, o workflow [continuous-delivery.yml](../.github/workflows/continuous-delivery.yml) já chama esse workflow usando `secrets: inherit`.

O workflow reutilizável publica o output `instance_public_ip`. Um job posterior pode consumi-lo assim:

```yaml
jobs:
  infra-provision:
    uses: ./.github/workflows/infra-provision.yml
    secrets: inherit

  next-step:
    needs: infra-provision
    runs-on: ubuntu-latest
    steps:
      - run: echo "IP público: ${{ needs.infra-provision.outputs.instance_public_ip }}"
```

## Observação sobre o backend

O arquivo [terraform/backend.tf](../terraform/backend.tf) usa:

```hcl
terraform {
  backend "oci" {}
}
```

Ou seja, o backend é configurado via parâmetros de inicialização (`-backend-config`) e não por variáveis do Terraform como `backend_bucket` ou `backend_key` declaradas no código.

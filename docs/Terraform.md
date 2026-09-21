# Terraform - Oracle Cloud Infrastructure

Este diretório contém a configuração de infraestrutura como código para provisionamento de recursos na Oracle Cloud Infrastructure (OCI).

> **ATENÇÃO**: Antes de utilizar este recurso, consulte a [documentação oficial do Terraform](https://registry.terraform.io/providers/oracle/oci/latest/docs) e [oci-cli](https://docs.oracle.com/pt-br/iaas/Content/API/Concepts/cliconcepts.htm).

## Estrutura do diretório

```
terraform/
|   └── modules/
|       └── oci_production/   # módulo de produção
|           ├── backend.tf    # configurações do backend externo
|           └── main.tf       # configuração do módulo
├── compartment.tf            # definições de compartimentos
├── compute.tf                # definições de instância de computação
├── network.tf                # definições de rede
├── outputs.tf                # Saídas
├── providers.tf              # configuração do provider OCI
├── security.tf               # definições de listas de segurança
├── storage.tf                # definições de armazenamento
└── variables.tf              # definição de variáveis
```

## Requisitos para execução

- Conta na Oracle Cloud Infraestructure (OCI)
- Tenancy configurada
- Usuário com permissões para executar ações na OCI
- Chave de API criada ([consulte artigo](https://www.oracle.com/br/technical-resources/articles/cloudcomp/utilizando-oci-cli-p1.html))

## Execução automatizada (GitHub Actions)

### Variáveis de configuração

Configure os seguintes `secrets` no repositório:

| Secret | Descrição | Exemplo | Obrigatório |
|--------|-----------|---------|-------------|
| `TENANCY_OCID` | OCID do tenancy | `ocid1.tenancy.oc1..aaaaaaa...` |Sim |
| `USER_OCID` | OCID do usuário | `ocid1.user.oc1..aaaaaaa...` | Sim |
| `KEY_FINGERPRINT` | Fingerprint da chave API | `aa:bb:cc:dd:...` | Sim |
| `PRIVATE_KEY` | Chave privada API | (conteúdo da chave PEM) | Sim |
| `REGION` | Região OCI | `us-sanjose-1` | Sim |
| `COMPARTMENT_NAME` | Nome do compartment | `Nome do Compartimento` | Sim |
| `VNC_CIDR_BLOCKS` | Blocos CIDR da VCN | `172.16.0.0/16` | Sim |
| `VNC_DISPLAY_NAME` | Nome de exibição da VCN | `Nome da VCN` | Sim |
| `VCN_DNS_LABEL` | Label DNS da VCN | `labelvnc` | Sim |
| `PUBLIC_SUBNET_CIDR_BLOCK` | CIDR da subnet pública | `172.16.10.0/24` | Sim |
| `HTTP_PORT` | CIDR da subnet pública | `8080` | Sim |
| `HTTPS_PORT` | CIDR da subnet pública | `8443` | Sim |
| `OS_NAMESPACE` | Nome do bucket | `e3ncabyyyxs4` | Sim |
| `BUCKET_NAME` | Nome do bucket | `Nome do Bucket` | Sim |
| `INSTANCE_AVAILABILITY_DOMAIN` | Domínio de disponibilidade | `Uocm:PHX-AD-1` | Sim |
| `INSTANCE_SHAPE` | Shape da instância | `VM.Standard.E6.Ax.Flex` | Sim |
| `OPERATING_SYSTEM` | Sistema operacional | `Canonical Ubuntu` | Sim |
| `OPERATING_SYSTEM_VERSION` | Versão do SO | `24.04` | Sim |
| `SSH_PUBLIC_KEY` | Chave pública SSH | `ssh-ed25519 pA7UVPcJE/VfjyVs9NH... email@host` | Sim |
| `INSTANCE_CREATE_VNIC_DETAILS_HOSTNAME_LABEL` | Hostname da instância | `oci-srv` | Sim |
| `INSTANCE_DISPLAY_NAME` | Nome da instância | `Instancia` | Sim |

## Execução manual (Local)

Em caso de execução manual, escolha uma das opções abaixo. Antes de executar o Terraform, configure o OCI CLI e substitua os valores `{{ secrets... }}` no arquivo `terraform/modules/oci_production/main.tf` pelos valores corretos do seu ambiente.

### Sem backend remoto

Nesta opção, o arquivo de estado (`terraform.tfstate`) é mantido localmente no diretório do módulo. Remova ou renomeie o  arquivo `terraform/modules/oci_production/backend.tf` e execute:

```bash
cd terraform/modules/oci_production
terraform init
terraform plan
terraform apply
```

Para destruir os recursos criados, use `terraform destroy`. Não exclua o arquivo de estado durante a execução, pois ele é necessário para que o Terraform acompanhe os recursos existentes.

### Com backend remoto (OCI)

Nesta opção, o estado é armazenado em um bucket do Object Storage. O bucket precisa ser criado **antes** do `terraform init`; caso contrário, a inicialização do backend falhará. O backend configurado neste projeto usa o bucket `bt-terraform` e uma chave específica por ambiente.

Obtenha o namespace do object storage e crie o bucket na tenancy, ou compartment escolhido, informando o OCID da tenancy, a região e o nome desejado:

```bash
export TENANCY_OCID="ocid1.tenancy.oc1..aaaa..."
export REGION="us-sanjose-1"
export NAMESPACE="$(oci os ns get --query 'data' --raw-output)"
export TFSTATE_BUCKET="bucket-terraform"

oci os bucket create \
	--compartment-id "$TENANCY_OCID" \
	--name "$TFSTATE_BUCKET" \
	--namespace-name "$NAMESPACE" \
	--region "$REGION" \
	--public-access-type NoPublicAccess \
	--storage-tier Standard
```

O nome do bucket deve ser único dentro do namespace. Se o bucket já existir, não é necessário criá-lo novamente. Em seguida, ajuste `terraform/modules/oci_production/backend.tf` com os valores locais:

```hcl
terraform {
	backend "oci" {
		bucket    = "bucket-terraform"
		key       = "oci_production/terraform.tfstate"
		region    = "us-sanjose-1"
		namespace = "<namespace-do-object-storage>"
	}
}
```

Depois, inicialize o módulo e confirme a migração ou configuração do estado:

```bash
cd terraform/modules/oci_production
terraform init -reconfigure
terraform plan
terraform apply
```

Para remover os recursos, use `terraform destroy`. O bucket do backend e o arquivo de estado não devem ser removidos como parte dessa operação.

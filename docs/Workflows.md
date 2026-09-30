# Workflows de CI/CD

Este documento descreve os workflows do GitHub Actions em `.github/workflows/` e como eles provisionam a infraestrutura OCI, implantam o Dokuwiki e verificam a aplicação.

## Visão geral

O pipeline completo é orquestrado por [continuous-delivery.yml](../.github/workflows/continuous-delivery.yml). Ele só é iniciado manualmente, pela opção **Run workflow** na aba **Actions**. Não há gatilhos configurados para `push` ou `pull_request`.

```text
Continuous Delivery (manual)
  └── infra: infra.yml
	  ├── scan: Checkov e upload SARIF
	  └── provision: fmt, init, validate, plan, apply
		  └── publica instance_public_ip
			  └── deploy: deploy.yml
				  ├── prepara SSH e Ansible
				  ├── aguarda a instância
				  └── executa o playbook
					  └── tests: tests.yml
						  └── verifica a resposta HTTP do Dokuwiki
```

Os jobs dependem uns dos outros: `provision` só começa após `scan`; `deploy` só começa após `infra`; e `tests` só começa após `deploy`. Um job que falhe interrompe os passos dependentes.

## Workflows disponíveis

### Continuous Delivery

Arquivo: [continuous-delivery.yml](../.github/workflows/continuous-delivery.yml)

É o ponto de entrada para uma execução completa. O workflow pode ser iniciado em **Actions > Continuous Delivery > Run workflow**. Ele herda os secrets do repositório e executa, na ordem:

1. `infra`: chama `infra.yml`, que analisa e provisiona a infraestrutura.
2. `deploy`: recebe o IP público produzido pelo job de infraestrutura e configura a instância com Ansible.
3. `tests`: recebe o IP público e executa o teste de saúde da aplicação.

O workflow não define parâmetros próprios para a execução manual; os valores de configuração são obtidos dos GitHub Actions Secrets.

### Infra Provision

Arquivo: [infra.yml](../.github/workflows/infra.yml)

Pode ser iniciado manualmente ou chamado por outro workflow (`workflow_call`). Quando chamado, publica o output `instance_public_ip`, que contém o valor de `oci_production_public_ip` do Terraform.

O job `scan` executa Checkov sobre `terraform/` e envia o resultado SARIF para GitHub Code Scanning. O job `provision`, dependente de `scan`, executa:

- `terraform fmt -check`
- `terraform init`, com configuração do backend OCI
- `terraform validate`
- `terraform plan -input=false -out=tfplan`
- `terraform apply -auto-approve tfplan`
- Leitura do IP público para disponibilizá-lo aos jobs seguintes

O backend remoto precisa estar previamente preparado. Para a lista de secrets e detalhes das variáveis, consulte [Terraform.md](Terraform.md).

### Deploy

Arquivo: [deploy.yml](../.github/workflows/deploy.yml)

Pode ser iniciado manualmente ou chamado por outro workflow. No pipeline principal, recebe `instance_public_ip` de `infra.yml`. O job:

1. Faz checkout do repositório e grava `SSH_PRIVATE_KEY` em `~/.ssh/ssh_key` com permissões restritas.
2. Configura Python 3.13 e instala Ansible, `ansible-lint` e as dependências de `ansible/requirements.yml`.
3. Executa `ansible-lint playbook.yml` e a verificação de sintaxe do playbook.
4. Chama `tests/instance_check.sh` para tentar estabelecer SSH com a instância.
5. Executa `ansible-playbook playbook.yml` com o inventário `hosts.yml` e a chave SSH.

Os secrets usados diretamente por este workflow incluem `SSH_PRIVATE_KEY`, `INSTANCE_USER`, `REGION`, `TENANCY_OCID`, `USER_OCID`, `FINGERPRINT`, `PRIVATE_KEY`, `PRIVATE_KEY_PASSWORD`, `BUCKET_NAME`, `OBJECT_NAME`, `OBJECT_NAME_FILE`, `PERSISTENT_DIR`, `CONTAINER_NAME`, `VOL_CONF_NAME` e `VOL_DATA_NAME`. O playbook e as roles usam esses valores para configurar a autenticação OCI, a persistência e o container. Consulte [Ansible.md](Ansible.md) para a configuração da automação.

### Tests

Arquivo: [tests.yml](../.github/workflows/tests.yml)

Pode ser chamado como workflow reutilizável (`workflow_call`) com a entrada obrigatória `instance_public_ip`. No pipeline completo, esse valor é o IP emitido por `infra.yml`.

O job executa `tests/app_health_check.sh`, que faz uma requisição HTTP para `http://<IP>/doku.php?id=wiki:welcome` e procura a mensagem `your wiki is now up and running`. Uma falha na requisição ou a ausência da mensagem faz o job falhar.

> O script recebe usuário e senha opcionais pelas variáveis `APP_USER` e `APP_PASS`. Para executar o teste sem usuário configurado, deixe os secrets `APP_USER` e `APP_PASS` sem conteúdo; isso corresponde ao modo sem autenticação descrito no próprio script. Configure ambos somente quando a aplicação exigir autenticação.

## Comportamento e pontos de atenção

- A infraestrutura é efetivamente criada ou atualizada durante o pipeline: `terraform apply -auto-approve` aplica o plano sem aprovação adicional. Inicie o workflow apenas quando essa alteração for desejada.
- O teste de saúde valida HTTP na porta 80 e uma frase específica da página inicial; ele não verifica HTTPS nem outras rotas.
- `tests/instance_check.sh` tenta SSH até 30 vezes, com intervalo de 10 segundos e timeout de conexão de 5 segundos. O script atual não termina com erro explicitamente se todas as tentativas falharem; nesse caso, o job segue para o playbook, que poderá falhar ao conectar.
- A etapa de upload SARIF em `infra.yml` usa `if: success() || failure()`, portanto tenta publicar o relatório mesmo se a análise falhar. Um erro na etapa de upload ainda pode afetar o resultado do job.

## Diagnóstico

- **Falha em `terraform init`:** confirme a existência e o acesso ao bucket de backend, além de `BACKEND_BUCKET`, `BACKEND_KEY`, `NAMESPACE` e das credenciais OCI.
- **Falha em `terraform plan` ou `apply`:** confira os valores `TF_VAR_*`, permissões da tenancy e disponibilidade da região/domínio de disponibilidade.
- **Falha na conexão SSH:** valide `SSH_PRIVATE_KEY`, `INSTANCE_USER`, a saída do IP público e o acesso de rede à instância.
- **Falha no Ansible:** consulte a saída de `ansible-lint`, `--syntax-check` e do playbook; confira também secrets de OCI e persistência.
- **Falha em Tests:** confirme que o Dokuwiki está acessível por HTTP no IP público e que `APP_USER` e `APP_PASS` correspondem às credenciais esperadas pelo script.

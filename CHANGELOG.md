  # Changelog
  
  Todas as alterações relevantes deste projeto serão documentadas neste arquivo. O formato baseia-se no [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), e este projeto segue o [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
  
  ## [1.6.2] - 2026-09-30

  ### Modificado
  - Workflow de provisionamento (`.github/workflows/infra.yml`)
    - Remove soft_fail do Checkov para falhar em findings de segurança

  ## [1.6.1] - 2026-09-30

  ### Corrigido
  - Terraform: Correções de segurança gerados à partir do fmt -chek e checkov
    - Corrige formatação do arquivo variables.tf
    - CKV_OCI_1: Ensure no hard coded OCI private key in provider
    - CKV_OCI_4: Ensure OCI Compute Instance boot volume has in-transit data encryption enabled
    - CKV_OCI_5: Ensure OCI Compute Instance has Legacy MetaData service endpoint disabled
    - CKV_OCI_7: Ensure OCI Object Storage bucket can emit object events
    - CKV_OCI_8: Ensure OCI Object Storage has versioning enabled
    - CKV_OCI_9: Ensure OCI Object Storage is encrypted with Customer Managed Key (SKIPPED)

  ## [1.6.0] - 2026-09-29

  ### Adicionado
  - Workflow de provisionamento (`.github/workflows/infra.yml`)
    - Job de scan de segurança com Checkov e upload SARIF para CodeQL
    - Validação de formatação Terraform com `terraform fmt -check`
  
  ### Modificado
  - Continuous Delivery (`.github/workflows/continuous-delivery.yml`)
    - Refatora job de provisionamento para usar novo workflow `infra.yml`
    - Adiciona permissões de segurança (contents, security-events)
    - Corrige referência de output do job provision

  ## [1.5.1] - 2026-09-29

  ### Modificado
  - Workflow de deploy via GitHub Actions (`.github/workflows/deploy.yml`)
    - Remoção de setup do ansible-lint via actions. Ele já está sendo instalado via pip
    - Configuração das variáveis de ambiente somente nos steps necessários

  ## [1.5.0] - 2026-09-28
  
  ### Adicionado
  - Workflow de deploy via GitHub Actions (`.github/workflows/deploy.yml`)
    - Execução automatizada do playbook Ansible na instância provisionada
    - Configuração de variáveis de ambiente via secrets
    - Validação com ansible-lint e syntax check
  - Script de verificação de prontidão da instância (`tests/instance_check.sh`)
    - Aguarda SSH estar disponível antes de prosseguir com o deploy
  
  ### Modificado
  - Ansible: adiciona configuração `host_key_checking = False` no ansible.cfg
  
  ## [1.4.2] - 2026-09-28

  ### Adicionado
  - Automação completa de configuração do ambiente com Ansible
    - Playbook principal e configuração de inventário
    - Roles: init (pacotes), requirements (OCI CLI + Docker), persistent (dados), deploy
  (container)
    - Documentação completa em `docs/Ansible.md`
    - Exemplo de variáveis de ambiente em `docs/samples/.env.example`
  
  ### Modificado
  - README.md: adicionada seção de documentação do Ansible

  ## [1.3.2] - 2026-09-25

  ### Corrigido
  - Continuous Delivery: correção de leitura do Terraform output.
    - Substituição do nome correto do output de ip público.

  ## [1.3.1] - 2026-09-25

  ### Adicionado
  - Continuous Delivery: pipeline de provisionamento de infraestrutura
    - Criação do arquivo `.github/workflows/continuous-delivery.yml`, para orquestração
    geral dos jobs de CD.
    - Criação do arquivo `.github/workflows/infra-provision.yml` para o provisionamento
    da infraestrutura usando Terraform.

  ## [1.2.1] - 2026-09-25

  ### Corrigido
  - Terraform: correção das variáveis de configuração quebravam o projeto
    - Substituição de placeholders literais `$VAR` por referências `var.var`
    - Adição de variáveis ausentes para autenticação OCI (`user_ocid`, `fingerprint`,
  `private_key`)
    - Correção do backend Terraform para usar configuração genérica

  ### Modificado
  - Terraform: reorganização da estrutura do módulo de produção
    - Separação entre root (variáveis) e módulo (recursos)
    - Arquivos de recurso movidos para `terraform/modules/oci_production/`
    - Arquivo `main.tf` do módulo substituído por passagem de variáveis via module call

  ## [1.1.0] - 2026-09-24

  ### Modificado
  - Terraform: simplificação dos outputs do módulo de produção
    - Remoção de outputs não utilizados

  - Terraform: migração de placeholders `{{ secrets.X }}` para variáveis de ambiente `$VAR`
    - Substituição em `backend.tf` e `main.tf` do módulo oci_production

  ## [1.0.0] - 2026-09-21
  
  ### Adicionado
  - Configuração completa de infraestrutura como código para Oracle Cloud Infrastructure (OCI)
    - Provider Terraform OCI v9.2.0 com autenticação ApiKey
    - Backend remoto para persistência de estado do ambiente
    - Compartment para isolamento de recursos de produção
    - VCN com rota padrão, DNS label e subnet pública
    - Lista de segurança para acessos HTTP/HTTPS
    - Instância de computação com IP público e acesso SSH
    - Bucket object storage para armazenamento de dados
    - Módulo Terraform para deploy automatizado de ambiente de produção
    - Documentação completa em `docs/Terraform.md`
  
  ### Modificado
  - Estrutura do repositório agora inclui diretórios `terraform/` e `docs/`
  
  ### Segurança
  - Credenciais externalizadas via secrets do GitHub Actions
  - Autenticação via API Key com rotação recomendada
  
  [Unreleased]: https://github.com/mafpbiaggi/dokuwiki-iac/compare/v1.0.0...HEAD
  [1.0.0]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.0.0
  [1.1.0]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.1.0
  [1.2.1]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.2.1
  [1.3.1]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.3.1
  [1.3.2]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.3.2
  [1.4.2]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.4.2
  [1.5.0]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.5.0
  [1.5.1]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.5.1
  [1.6.0]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.6.0
  [1.6.1]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.6.1
  [1.6.2]: https://github.com/mafpbiaggi/dokuwiki-iac/releases/tag/v1.6.2

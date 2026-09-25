  # Changelog
  
  Todas as alterações relevantes deste projeto serão documentadas neste arquivo. O formato baseia-se no [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), e este projeto segue o [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

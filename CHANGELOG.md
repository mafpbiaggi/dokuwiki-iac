  # Changelog
  
  Todas as alterações relevantes deste projeto serão documentadas neste arquivo. O formato baseia-se no [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), e este projeto segue o [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
  
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

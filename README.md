# Dokuwiki IaC

Este repositório é um complemento para o projeto principal em [github.com/mafpbiaggi/dokuwiki](https://github.com/mafpbiaggi/dokuwiki).

## Objetivo

Ele foi criado para automatizar o deploy e a infraestrutura necessária para executar o Dokuwiki em ambiente de nuvem, separando a parte de provisionamento e configuração da aplicação do código do próprio projeto.

A ideia é manter o repositório do aplicativo focado no conteúdo e na lógica da solução, enquanto este repositório cuida de:

- Provisionamento de infraestrutura na nuvem;
- Criação de redes, instâncias e recursos necessários;
- Configuração automática do ambiente de execução;
- Implantação consistente do Dokuwiki em ambientes reproducíveis.

## Estrutura do projeto

```
├── .github/
|   ├── Contributing.md/
|   └── workflows
|       ├── continuous-delivery.yml  # orquestração de jobs do pipeline
|       ├── infra.yml                # provionamento da infraestrutura com Terraform
|       ├── deploy.yml               # configuração da instância e deploy da aplicação com Ansible
|       └── tests.yml                # testes de saúde da aplicação após deploy
├── docs/                            # documentação detalhada sobre recursos específicos
|   ├── samples                      # arquivos de exemplo
|   ├── Ansible.md
|   ├── Terraform.md
|   └── Workflows.md
├── terraform/                       # arquivos de infraestrutura como código
├── tests/                           # scripts de validação e verificação de saúde da aplicação
├── CHANGELOG                        # documentação de mudanças no projeto
└── README.md                        # documentação geral do projeto
```

## Relacionamento com o projeto principal

O projeto de aplicação principal está em:

- https://github.com/mafpbiaggi/dokuwiki

Este repositório atua como camada de infraestrutura e automação para disponibilizar esse projeto em nuvem de forma padronizada e repetível.

## Terraform

O diretório `terraform/` contém a configuração de infraestrutura como código para Oracle Cloud Infrastructure (OCI).

Consulte a [documentação completa](docs/Terraform.md) para detalhes sobre:

- Variáveis de configuração
- Configuração de secrets para GitHub Actions
- Uso e comandos do Terraform

## Ansible

O diretório `ansible/` contém a automação de configuração do ambiente remoto para execução do Dokuwiki.

Consulte a [documentação completa](docs/Ansible.md) para detalhes sobre:

- Estrutura do diretório e roles
- Playbook principal e execução
- Inventário, variáveis e autenticação OCI
- Instalação de dependências e configuração do Docker
- Persistência de dados e deploy da aplicação
- Boas práticas de segurança e troubleshooting

## Workflows

Os workflows do GitHub Actions automatizam a análise e o provisionamento da infraestrutura, a configuração da instância e a verificação da aplicação.

Consulte a [documentação completa dos workflows](docs/Workflows.md) para detalhes sobre:

- Pipeline de CI/CD e dependências entre jobs
- Execução e workflows reutilizáveis
- Secrets, entradas e saídas
- Verificações do Terraform, Ansible e saúde da aplicação
- Limitações conhecidas e troubleshooting

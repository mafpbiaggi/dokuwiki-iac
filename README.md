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
├── docs/                # documentação detalhada sobre recursos específicos
|   ├── samples          # arquivos de exemplo
|   └── Terraform.md            
├── terraform/           # arquivos de infraestrutura como código
├── CHANGELOG            # documentação de mudanças no projeto
└── README.md            # documentação geral do projeto
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

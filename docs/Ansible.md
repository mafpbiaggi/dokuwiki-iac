# Ansible

Este diretório contém a automação da configuração necessária para executar o Dokuwiki.

## Objetivo

O objetivo desta automação é preparar a instância remota para receber a aplicação, instalando e configurando os componentes essenciais do ambiente de execução.

A ideia é manter a lógica da aplicação separada da infraestrutura, permitindo que o ambiente seja configurado de forma padronizada e repetível.

Neste diretório, o Ansible realiza:

- preparação do sistema operacional;
- instalação de dependências básicas;
- configuração do OCI CLI;
- instalação e configuração do Docker;
- habilitação de serviços e ajustes de usuário;
- implantação e persistência da aplicação.

## Estrutura do diretório

```text
ansible/
├── ansible.cfg
├── hosts.yml
├── playbook.yml
├── requirements.yml
├── group_vars/
│   └── all.yml
├── roles/
│   ├── deploy/
│   ├── init/
│   ├── persistent/
└── └── requirements/
```

## Playbook principal

O ponto de entrada da automação é o arquivo `playbook.yml`.

Esse playbook executa as roles na seguinte ordem:

- `init`
- `requirements`
- `deploy`
- `persistent`

A execução do playbook pode ser feita com o comando:

```bash
cd ansible
ansible-playbook playbook.yml -i hosts.yml -u "$INSTANCE_USER" --private-key "$SSH_KEY_FILE"
```

Antes da execução, é recomendável instalar as dependências da coleção:

```bash
ansible-galaxy install -r requirements.yml
```

## Configuração do controlador

Para padronizar a execução do Ansible, recomenda-se manter um arquivo `ansible.cfg` no diretório `ansible/` com as configurações básicas do ambiente. Exemplo:

```ini
[defaults]
inventory = hosts.yml
roles_path = ./roles

[ssh_connection]
pipelining = True
```

Esse arquivo ajuda a evitar repetição de flags na linha de comando e deixa o ambiente mais previsível e fácil de manter.

## Roles

### init

A role `init` prepara a base do sistema operacional para a aplicação.

Entre as ações realizadas, estão:

- instalação de pacotes básicos do sistema;
- atualização do cache de pacotes;
- configuração inicial da instância.

Os pacotes instalados nesta etapa incluem:

- bash-completion
- vim
- git
- curl
- unzip
- bzip2

### requirements

A role `requirements` configura os requisitos para a execução da aplicação.

As principais ações desta etapa são:

- criação do diretório de configuração do OCI;
- download e instalação da Oracle Cloud Infrastructure CLI;
- configuração do perfil e da autenticação do OCI;
- instalação de dependências do Docker;
- configuração do repositório do Docker CE;
- instalação do Docker e do Docker Compose;
- ativação do serviço `docker`;
- inclusão do usuário no grupo `docker`.

### deploy

A role `deploy` é responsável pela implantação da aplicação no ambiente configurado.

Ela define e executa a criação do container da aplicação, incluindo a imagem Docker, diretrizes de execução e variáveis associadas ao Dokuwiki.

### persistent

A role `persistent` cuida dos recursos que precisam permanecer entre reinicializações e execuções do ambiente.

Ela trata aspectos de persistência do Dokuwiki, como diretórios e volumes configurados para armazenamento de dados e arquivos de configuração.

## Requisitos para execução

Para executar este playbook com sucesso, o ambiente de automação precisa atender aos seguintes requisitos:

- Python 3 instalado no controlador;
- Ansible Core instalado na máquina que dispara a automação;
- acesso SSH configurado para o host remoto;
- chave privada com permissões corretas para a instância alvo;
- usuário remoto com permissão de sudo;
- dependências do Ansible instaladas corretamente.

> ATENÇÃO: o arquivo `requirements.yml` define a coleção necessária para a automação:

```yaml
collections:
  - name: community.docker
    version: ">=5.3.0"
```

Antes da execução do playbook, é necessário instalar essa dependência.

## Execução automatizada (GitHub Actions)

### Variáveis de configuração

Configure os seguintes `secrets` no repositório:

| Secret | Descrição | Exemplo | Obrigatório |
|--------|-----------|---------|-------------|
| `USER_OCID` | OCID do usuário OCI | `ocid1.user.oc1..aaaaaaa...` | Sim |
| `FINGERPRINT` | Fingerprint da chave API | `aa:bb:cc:dd:...` | Sim |
| `TENANCY_OCID` | OCID do tenancy | `ocid1.tenancy.oc1..aaaaaaa...` | Sim |
| `PRIVATE_API_KEY` | Chave privada API do OCI em formato PEM | `(conteúdo da chave PEM)` | Sim |
| `REGION` | Região OCI | `us-sanjose-1` | Sim |
| `PRIVATE_KEY_PASSWORD` | Passphrase da chave privada OCI | `passphrase` | Sim |
| `BUCKET_NAME` | Nome do bucket | `bucket-dokuwiki` | Sim |
| `OBJECT_NAME` | Nome do objeto de persistência do Dokuwiki | `dados-dokuwiki` | Sim |
| `OBJECT_NAME-FILE` | Nome do arquivo de persistência | `arquivo.tgz` | Sim |
| `CONTAINER_NAME` | Nome do container do Dokuwiki | `dokuwiki` | Sim |
| `VOL_CONF_NAME` | Nome do volume de configuração | `conf` | Sim |
| `VOL_DATA_NAME` | Nome do volume de dados | `data` | Sim |
| `PERSISTENT_DIR` | Diretório base de persistência | `dados-dokuwiki` | Sim |
| `INSTANCE_USER` | Nome do usuário da instância | `usuario` | Sim |
| `HOST` | IP público da instância | `123.123.123.1` | Sim |

Esses valores alimentam o arquivo `group_vars/all.yml` e são utilizados durante a geração do perfil do OCI, a criação do arquivo de chave e a configuração do container da aplicação.

> Consulte o arquivo `docs/samples/.env.example` para mais detalhes.

## Inventário e autenticação

O inventário do ambiente está no arquivo `hosts.yml`.

Esse arquivo define o grupo `oci_production` e indica o host remoto `oci_server`.

```yaml
oci_production:
  hosts:
    oci_server:
      ansible_host: "{{ host }}"
      ansible_user: "{{ instance_user }}"
      ansible_python_interpreter: auto_silent
```

Essa forma torna a configuração mais explícita e facilita a leitura do arquivo de inventory. No ambiente de execução real, é recomendável também definir explicitamente a chave SSH, por exemplo:

```yaml
ansible_ssh_private_key_file: "{{ ssh_key_file }}"
```

No entanto, em cenários automatizados, o mais comum é passar o valor por linha de comando ou por variável de ambiente.

As variáveis globais do ambiente estão em `group_vars/all.yml`. Nesse arquivo, o Ansible define valores como usuário da instância, configuração do OCI, imagem do Dokuwiki e detalhes de persistência do container.

## Boas práticas para segredos

Como o projeto trabalha com autenticação OCI, credenciais e dados sensíveis, recomenda-se:

- manter secrets fora do código-fonte;
- usar `ansible-vault` para dados sensíveis quando necessário;
- preferir `GitHub Actions Secrets` ou equivalente para ambientes CI/CD;
- evitar versionar chaves privadas ou arquivos PEM no repositório;
- segregar variáveis públicas e sensíveis em arquivos distintos.

Exemplo de uso com `ansible-vault`:

```bash
ansible-vault encrypt group_vars/all.yml
```

## Tags e execução parcial

Para facilitar o diagnóstico e execução incremental, a automação pode ser organizada com `tags` por etapa, por exemplo:

- `init`
- `requirements`
- `deploy`
- `persistent`

Exemplo de execução parcial:

```bash
ansible-playbook playbook.yml -i hosts.yml --tags requirements
```

Isso permite validar uma etapa específica sem reexecutar todo o playbook.

## Atenção aos módulos dnf

Este projeto faz uso explícito do módulo `dnf` para instalação e preparação do sistema, especialmente em tarefas como:

```yaml
- name: Install default packages
  ansible.builtin.dnf:
    pkg:
      - bash-completion
      - vim
      - git
      - curl
      - unzip
      - bzip2
    update_cache: true
  become: true
```

Também é usado na instalação de dependências e na configuração do repositório Docker:

```yaml
- name: Install docker dependencies
  ansible.builtin.dnf:
    name: dnf-plugins-core
    state: present
    update_cache: true
  become: true
```

Essas tarefas indicam que a automação foi desenhada para sistemas operacionais baseados em RHEL, como:

- Fedora
- CentOS
- Oracle Linux
- Red Hat Enterprise Linux

## Compatibilidade

Este playbook foi projetado para ambientes Linux que utilizam o gerenciador de pacotes DNF.

Se o host alvo não for compatível com esse modelo, a automação pode falhar ou exigir ajustes. Isso ocorre porque:

- o módulo `dnf` é específico para sistemas do ecossistema RPM/DNF;
- o repositório do Docker para instalação do pacote é configurado com `dnf config-manager`;
- as dependências e os caminhos do sistema assumem a estrutura de distribuições baseadas em RHEL.

Em resumo, a automação deste diretório foi construída para hosts compatíveis com `dnf`, especialmente em cenários de infraestrutura Linux orientados a Oracle Cloud, Docker e sistemas RHEL-like.

## Validação e troubleshooting

Para reduzir falhas em produção, recomenda-se validar a automação com alguns passos simples antes do deploy completo:

- verificar conectividade SSH;
- validar o inventário com `ansible-inventory --list`;
- validar sintaxe com `ansible-playbook --syntax-check`;
- rodar a playbook em modo de simulação com `--check` quando possível;
- verificar se o Docker daemon está ativo após a etapa de requisitos;
- confirmar se os volumes persistentes foram criados corretamente;
- validar o container com `docker ps` e por HTTP no endpoint da aplicação.

Exemplo:

```bash
ansible-playbook playbook.yml -i hosts.yml --syntax-check
ansible-playbook playbook.yml -i hosts.yml --check
```

## Conclusão

Este diretório oferece uma automação bem estruturada para provisionar e manter o Dokuwiki em ambiente Linux baseado em Oracle Cloud e Docker. A documentação foi ajustada para refletir melhor as boas práticas de automação com Ansible, incluindo:
- configuração do controlador;
- organização do inventory;
- uso de segredos e variáveis sensíveis;
- execução parcial com `tags`;
- validação e troubleshooting;
- atenção às peculiaridades de sistemas DNF/RHEL-like.
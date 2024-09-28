# AuthCloud

Este projeto contém a aplicação **authcloud**, focada em expor uma api web que recebe por parametros um JWT (string) e verifica se é valida conforme regras abaixo:

- Deve ser um JWT válido
- Deve conter apenas 3 claims (Name, Role e Seed)
- A claim Name não pode ter carácter de números
- A claim Role deve conter apenas 1 dos três valores (Admin, Member e External)
- A claim Seed deve ser um número primo.
- O tamanho máximo da claim Name é de 256 caracteres.

## Arquitetura

![Diagrama do Sistema](docs/Arquitetura.drawio.png)

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/chjsoliveira/backend-challenge.git
   ```

2. Navegue até o diretório do projeto:
   ```bash
   cd backend-challenge/src
   ```

3. Instale as dependências:
   ```bash
   dotnet restore
   ```

4. Compile o projeto:
   ```bash
   dotnet build
   ```
   
## Uso

Execute a aplicação localmente:

```bash
dotnet run --project src/app/authcloud.csproj
```

A API estará disponível em `http://localhost:5088`.

## Documentação dos Endpoints

Para detalhes sobre os endpoints da API, consulte o [README dos Endpoints](docs/endpoints.md).

## Testes

Para rodar os testes unitários:

```bash
dotnet test src/unit-tests/authcloud.UnitTests.csproj
```

## Infraestrutura

- **Helm**: Use o chart localizado em `infra/helm-chart` para o deploy no Kubernetes.
- **Terraform**: Os scripts de infraestrutura do Terraform estão em `infra/terraform`. Certifique-se de configurar as variáveis em `variables.tf` antes de aplicar.

## Estrutura de Pastas

```bash
.
¦
+-- docs/                   # Documentação do projeto
¦   +-- Arquitetura.drawio   # Diagrama de arquitetura (editável)
¦   +-- Arquitetura.drawio.png  # Diagrama da arquitetura em formato PNG
¦
+-- infra/                  # Infraestrutura para deployment
¦   +-- helm-chart/         # Helm chart para Kubernetes
¦   ¦   +-- values.yaml     # Valores configuráveis do Helm chart
¦   ¦   +-- templates/      # Templates Kubernetes para deployment
¦   ¦       +-- deployment.yaml # Definição do deployment no Kubernetes
¦   ¦       +-- service.yaml    # Definição do service no Kubernetes
¦   +-- terraform/          # Configurações de infraestrutura como código (IaC) usando Terraform
¦       +-- aws-ecr.tf      # Definição do repositório ECR na AWS
¦       +-- aws-ecs.tf      # Configuração do ECS (Elastic Container Service)
¦       +-- aws-load-balancer.tf # Configuração do Load Balancer da AWS
¦       +-- aws-role.tf     # Políticas e roles da AWS
¦       +-- aws-sg.tf       # Configuração de security groups da AWS
¦       +-- main.tf         # Arquivo principal do Terraform
¦       +-- variables.tf    # Variáveis de entrada para o Terraform
¦
+-- src/                    # Código-fonte da aplicação authcloud
¦   +-- Dockerfile          # Definição do container Docker
¦   +-- unit-tests/         # Testes unitários da aplicação
¦   +-- app/                # Aplicação principal

```

## Documentação

Os diagramas de arquitetura estão disponíveis no diretório `docs/`.


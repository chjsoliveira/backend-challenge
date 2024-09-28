# backend-challenge

Este projeto cont�m a aplica��o **authcloud**, focada em expor uma api web que recebe por parametros um JWT (string) e verifica se � valida conforme regras abaixo:

Deve ser um JWT v�lido
Deve conter apenas 3 claims (Name, Role e Seed)
A claim Name n�o pode ter car�cter de n�meros
A claim Role deve conter apenas 1 dos tr�s valores (Admin, Member e External)
A claim Seed deve ser um n�mero primo.
O tamanho m�ximo da claim Name � de 256 caracteres.

## Instala��o

1. Clone o reposit�rio:
   ```bash
   git clone https://github.com/seu-usuario/authcloud.git
   ```

2. Navegue at� o diret�rio do projeto:
   ```bash
   cd authcloud
   ```

3. Instale as depend�ncias:
   ```bash
   dotnet restore
   ```

4. Compile o projeto:
   ```bash
   dotnet build
   ```

## Estrutura de Pastas

```bash
.
�
+-- docs/                   # Documenta��o do projeto
�   +-- Arquitetura.drawio   # Diagrama de arquitetura (edit�vel)
�   +-- Arquitetura.drawio.png  # Diagrama da arquitetura em formato PNG
�
+-- infra/                  # Infraestrutura para deployment
�   +-- helm-chart/         # Helm chart para Kubernetes
�   �   +-- values.yaml     # Valores configur�veis do Helm chart
�   �   +-- templates/      # Templates Kubernetes para deployment
�   �       +-- deployment.yaml # Defini��o do deployment no Kubernetes
�   �       +-- service.yaml    # Defini��o do service no Kubernetes
�   +-- terraform/          # Configura��es de infraestrutura como c�digo (IaC) usando Terraform
�       +-- aws-ecr.tf      # Defini��o do reposit�rio ECR na AWS
�       +-- aws-ecs.tf      # Configura��o do ECS (Elastic Container Service)
�       +-- aws-load-balancer.tf # Configura��o do Load Balancer da AWS
�       +-- aws-role.tf     # Pol�ticas e roles da AWS
�       +-- aws-sg.tf       # Configura��o de security groups da AWS
�       +-- main.tf         # Arquivo principal do Terraform
�       +-- variables.tf    # Vari�veis de entrada para o Terraform
�
+-- src/                    # C�digo-fonte da aplica��o authcloud
�   +-- Dockerfile          # Defini��o do container Docker
�   +-- unit-tests/         # Testes unit�rios da aplica��o
�   +-- app/                # Aplica��o principal

```

## Uso

Execute a aplica��o localmente:

```bash
dotnet run --project src/app/authcloud.csproj
```

A API estar� dispon�vel em `http://localhost:5000`.

## Testes

Para rodar os testes unit�rios:

```bash
dotnet test src/unit-tests/authcloud.UnitTests.csproj
```

## Infraestrutura

- **Helm**: Use o chart localizado em `infra/helm-chart` para o deploy no Kubernetes.
- **Terraform**: Os scripts de infraestrutura do Terraform est�o em `infra/terraform`. Certifique-se de configurar as vari�veis em `variables.tf` antes de aplicar.

## Documenta��o

Os diagramas de arquitetura est�o dispon�veis no diret�rio `docs/`.

![Diagrama do Sistema](docs/Arquitetura.drawio.png)

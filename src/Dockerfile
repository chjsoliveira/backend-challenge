# Usar a imagem base do .NET SDK para compilar a aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
EXPOSE 80

# Copiar o arquivo de projeto e restaurar dependências
COPY *.sln ./
COPY app/*.csproj ./app/
RUN dotnet restore "app/authcloud.csproj"

# Copiar o restante do código e compilar a aplicação
COPY . .
RUN dotnet publish app -c Release -o out

# Usar a imagem base do .NET Runtime para executar a aplicação
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "authcloud.dll"]

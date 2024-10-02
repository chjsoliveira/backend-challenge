# Usar a imagem base do .NET SDK para compilar a aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar o arquivo de projeto e restaurar dependências
COPY ["app/authcloud.csproj", "app/"]
RUN dotnet restore "app/authcloud.csproj"

# Copiar o restante do código e compilar a aplicação
COPY . .
WORKDIR "/src/app"
RUN dotnet publish "authcloud.csproj" -c Release -o /app/publish

# Usar a imagem base do .NET Runtime para executar a aplicação
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "authcloud.dll"]

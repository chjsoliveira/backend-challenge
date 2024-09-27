FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["app/AuthCloud.csproj", "app/"]
RUN dotnet restore "app/AuthCloud.csproj"

COPY . .

WORKDIR "/src/app"
RUN dotnet build "AuthCloud.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AuthCloud.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AuthCloud.dll"]

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["app/authcloud.csproj", "app/"]
RUN dotnet restore "app/authcloud.csproj"

COPY . .

WORKDIR "/src/app"
RUN dotnet build "authcloud.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "authcloud.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "authcloud.dll"]

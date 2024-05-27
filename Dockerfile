#syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/runtime:8.0-jammy AS base
USER app
WORKDIR /app

#FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
# Install NativeAOT build prerequisites
USER root
RUN apt-get update && apt-get install -y --no-install-recommends clang zlib1g-dev

WORKDIR /src
COPY ["PayPowerBill.csproj", "."]
RUN dotnet restore "./PayPowerBill.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "PayPowerBill.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PayPowerBill.csproj" -c Release -o /app/publish -r linux-x64 

FROM base AS final
USER root
WORKDIR /app
COPY --from=publish /app/publish .
RUN /app/PayPowerBill install
ENTRYPOINT ["PayPowerBill"]
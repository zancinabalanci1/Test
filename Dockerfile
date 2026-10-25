
#Osnovna slika za izvajanje aplikacije
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER $APP_UID
WORKDIR /app

ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

#Gradnja aplikacije
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["Test/Test.csproj", "Test/"]
RUN dotnet restore "Test/Test.csproj"

COPY . .
WORKDIR "/src/Test"
RUN dotnet build "Test.csproj" -c $BUILD_CONFIGURATION -o /app/build

#Objava aplikacije
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Test.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

#Končna slika
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Test.dll"]

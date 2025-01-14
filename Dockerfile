FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["BackEndAaaapero/BackEndAaaapero.csproj", ""]
RUN dotnet restore "./BackEndAaaapero.csproj"
COPY BackEndAaaapero .
WORKDIR "/src/."
RUN dotnet build "BackEndAaaapero.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BackEndAaaapero.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet BackEndAaaapero.dll

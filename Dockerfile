FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["SolutionLog.csproj", "./"]
RUN dotnet restore "SolutionLog.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "SolutionLog.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SolutionLog.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SolutionLog.dll"]

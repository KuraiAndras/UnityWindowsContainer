# syntax=docker/dockerfile:1

# Editor

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 as editor

SHELL ["powershell", "-command"]

RUN Invoke-WebRequest "https://aka.ms/vs/16/release/vs_community.exe" -OutFile "$env:TEMP\vs_community.exe" -UseBasicParsing
RUN & "$env:TEMP\vs_community.exe" --add Microsoft.VisualStudio.Workload.ManagedGame --quiet --wait --norestart --noUpdateInstaller | Out-Default

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
RUN choco install git git-lfs openjdk --no-progress -y

ARG UnityVersion
ARG UnityInstallPath

RUN choco install unity --params="$env:UnityInstallPath" --version="$env:UnityVersion" --no-progress -y --ignore-package-exit-codes=3010

# Android

RUN choco install unity-android --params="$env:UnityInstallPath" --version="$env:UnityVersion" --no-progress -y --ignore-package-exit-codes=3010

ARG NDKPath
ARG SDKPath
ARG OpenJDKPath

COPY ["NDK", $NDKPath]
COPY ["SDK", $SDKPath]
COPY ["OpenJDK", $OpenJDKPath]

#!/bin/bash
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# APT always -y
RUN \
  echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Install basic command-line utilities
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  software-properties-common \
  wget \
  locales \
  gnupg \
  lsb-release \
  ca-certificates \
  unzip \
  sudo \
  curl && \
  rm -rf /var/lib/apt/lists/*

# Setup the locale
ENV LANG en_GB.UTF-8
ENV LC_ALL $LANG
RUN \
  locale-gen $LANG && \
  update-locale
# Install build essential tools
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential && \
  rm -rf /var/lib/apt/lists/*
# Install Azure CLI
RUN \
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
  rm -rf /var/lib/apt/lists/*

#Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io

# Install OpenJDK's
ENV DEFAULT_JDK_VERSION=11
RUN \
  apt-add-repository -y ppa:openjdk-r/ppa
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  openjdk-11-jdk && \
  rm -rf /var/lib/apt/lists/*

RUN \
  update-alternatives --set java /usr/lib/jvm/java-${DEFAULT_JDK_VERSION}-openjdk-amd64/bin/java
ENV JAVA_HOME_11_X64=/usr/lib/jvm/java-11-openjdk-amd64 \
  JAVA_HOME=/usr/lib/jvm/java-${DEFAULT_JDK_VERSION}-openjdk-amd64 \
  JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

ARG ANDROID_SDK_VERSION=7302050
ENV ANDROID_SDK_ROOT /opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
  unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
  mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/tools && \
  rm *tools*linux*.zip
# Clean system
RUN \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /etc/apt/sources.list.d/*

# Install Azure Pipelines Agent
COPY root /
WORKDIR /azp
RUN chmod +x start.sh
CMD ["./start.sh"]

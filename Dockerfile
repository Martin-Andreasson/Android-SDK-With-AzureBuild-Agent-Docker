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
    apt-transport-https \
    ca-certificates \
    curl \
    dbus \
    fakeroot \
    git \
    gpg-agent \
    iputils-ping \
    jq \
    libcurl4 \
    libgconf-2-4 \
    libsecret-1-dev \
    libssl1.0 \
    libunwind8 \
    libxkbfile-dev \
    libxss1 \
    locales \
    netcat \
    openssh-client \
    pkg-config \
    rpm \
    rsync\
    shellcheck \
    software-properties-common \
    sudo  \
    tzdata \
    unzip \
    wget \
    xorriso \
    xvfb \
    xz-utils \
    zip \
    zsync && \
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
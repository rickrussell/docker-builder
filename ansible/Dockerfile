# Ansible Environment
#
# NAME dockerhub/rickrussell/ansible
# VERSION 2.2.0

FROM debian:jessie

MAINTAINER Rick Russell <noneck@noneck.io>

# Install dependencies
RUN buildDeps=' \
      build-essential \
      libffi-dev \
      libssl-dev \
      python-dev \
      python-setuptools \
    ' \
    && set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --fix-missing -y \
      $buildDeps \
      ca-certificates \
      openssl \
      curl \
      git \
      python \
    && easy_install pip \
    && pip install pyOpenSSL ndg-httpsclient pyasn1 ansible boto boto3 cryptography \
    && pip install python-dateutil --upgrade \
    && pip install pytz --upgrade \
    && apt-get purge -y --auto-remove \
      -o APT::AutoRemove::RecommendsImportant=false \
      -o APT::AutoRemove::SuggestsImportant=false \
      $buildDeps \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 jenkins && useradd -u 1001 -g 1001 jenkins

# Download the latest ansible modules
# TODO: Check to see if these are still needed
RUN git clone -q https://github.com/ansible/ansible-modules-core.git /ansible-modules-core \
    && cd /ansible-modules-core \
    && git fetch --all \
    && git checkout stable-2.2

RUN git clone -q https://github.com/ansible/ansible-modules-extras.git /ansible-modules-extras \
    && cd /ansible-modules-extras \
    && git fetch --all \
    && git checkout stable-2.2

# Add those modules to the ansible library search path
ENV ANSIBLE_LIBRARY /ansible-modules-core:/ansible-modules-extras

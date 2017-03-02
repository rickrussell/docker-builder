# Rick's Base Image
#
# NAME rickrussell/base
# VERSION 0.1.0

FROM debian:8

MAINTAINER Rick Russell <noneck@noneck.io>

# Install dependencies
# note: build-essential is required for npm installs
RUN apt-get update && apt-get install --fix-missing --no-install-recommends -y \
    openssh-client \
    build-essential \
    python2.7 \
    python2.7-dev \
    python-pip \
    ruby \
    ruby-dev \
    git \
    vim \
    wget \
    curl \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Install Node.js and npm (newer version than what's available on apt)
RUN curl -s https://nodejs.org/dist/v0.10.40/node-v0.10.40-linux-x64.tar.gz \
    | tar -C /usr/local --strip-components 1 -xzf -
RUN npm install -g npm@2.14.11

# Install bundler to install ruby dependencies
RUN echo 'gem: --no-document' > ~/.gemrc ; gem install bundler

# Set up SSH config for GitHub
RUN echo "IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config && \
    mkdir -p /root/.ssh/ && \
    echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

##
# Install ONVAULT (https://github.com/dockito/vault)
RUN curl -Lo /usr/local/bin/ONVAULT https://raw.githubusercontent.com/dockito/vault/v1.7.2/ONVAULT \
    && chmod +x /usr/local/bin/ONVAULT

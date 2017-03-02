# VERSION 1.7.1.3
# AUTHOR: Rick Russell <noneck@noneck.io>
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t dockerhub/rickrussell/docker-airflow .
# SOURCE: https://github.com/rickrussell/docker-builder/airflow
# NAME rickrussell/airflow

FROM debian:jessie
MAINTAINER Rick Russell <noneck@noneck.io>

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.7.1.3
ENV AIRFLOW_HOME /usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL  en_US.UTF-8

RUN set -ex \
    && buildDeps=' \
        python-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
    ' \
    && echo "deb http://http.debian.net/debian jessie-backports main" >/etc/apt/sources.list.d/backports.list \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        apt-utils \
        curl \
        git-core \
        netcat \
        locales \
        redis-tools \
        vim-common \
        vim-tiny \
        wget \
    && apt-get install -yqq -t jessie-backports python-requests libpq-dev \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

RUN wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
RUN python /tmp/get-pip.py

RUN pip install Cython \
    && pip install pistachio==2.0.5 \
    && pip install pytz==2015.7 \
    && pip install cryptography \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install psycopg2 \
    && pip install pandas==0.18.1 \
    && pip install celery==3.1.23 \
    && pip install redis \
    && pip install airflow[celery,postgres,hive,hdfs,jdbc,slack,s3]==$AIRFLOW_VERSION \
    && apt-get remove --purge -yqq $buildDeps \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME}
RUN chown -R airflow: /entrypoint.sh

EXPOSE 8080/tcp 5555/tcp 8793/tcp

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]

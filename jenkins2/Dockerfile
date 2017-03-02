# noneck Base Image
#
# NAME dockerhub/rickrussell/jenkins
# VERSION 2.19.1-alpine

FROM jenkins:2.19.1-alpine

MAINTAINER Rick Russell <noneck@noneck.io>

USER root

# This group id is subject to change based on the `docker-engine` deb and the noneck base AMI
RUN addgroup -g 998 -S docker \
    && adduser jenkins docker \
    && curl -o /usr/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 \
    && chmod 755 /usr/bin/docker

USER jenkins

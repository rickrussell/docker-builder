# Local Nginx proxy for development
#
# NAME dockerhub/rickrussell/local-nginx
# VERSION 0.1.5

FROM nginx:latest

MAINTAINER Rick Russell <noneck@noneck.io>

COPY nginx /etc/nginx
COPY init.sh /init.sh

EXPOSE 80 81 83 443 8093 8094 8095

CMD ["/init.sh"]

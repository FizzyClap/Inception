FROM alpine:3.20
RUN apk update && apk upgrade && apk add \
 openssl\
 nginx\
 curl\
 vim\
 sudo
RUN rm -f /etc/nginx/nginx.conf
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/script.sh /setup_nginx.sh
RUN chmod -R +x /setup_nginx.sh
EXPOSE 443
CMD ["sh", "/setup_nginx.sh"]

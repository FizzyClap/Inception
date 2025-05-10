FROM	alpine:3.20

RUN	apk update && apk upgrade && apk add \
	mariadb\

RUN	rm -f /etc/mariadb/my.cnf

COPY	./mariadb/config/mariadb.conf /etc/mariadb/my.cnf

COPY	./mariadb/tools/script.sh /setup_mariadb.sh

RUN	chmod -R +x /setup_mariadb.sh

EXPOSE	3306

CMD ["sh", "/setup_mariadb.sh"]

#docker run --publish 8081:80 -v /root/Dockers/LogAnalyzer/config.php:/var/www/localhost/htdocs/config.php -d tomdyg/loganalyzer
#docker service create --replicas 2 --publish 8081:80 --mount type=bind,src=/root/Dockers/LogAnalyzer/config.php,dst=/var/www/localhost/htdocs/config.php tomdyg/loganalyzer

FROM alpine:latest

RUN apk --no-cache update && apk --no-cache upgrade
RUN apk --no-cache add apache2 php5-apache2 php5-mysqli php5-gd

ADD loganalyzer-4.1.6.tar.gz /
RUN cp -r /loganalyzer-4.1.6/src/* /var/www/localhost/htdocs
RUN rm -rf /loganalyzer-4.1.6
RUN touch /var/www/localhost/htdocs/config.php
RUN chmod 666 /var/www/localhost/htdocs/config.php

COPY docker-run /usr/local/bin/docker-run
RUN chmod +x /usr/local/bin/docker-run
RUN mkdir -p /run/apache2/
RUN echo "ServerName localhost">> /etc/apache2/httpd.conf
RUN sed -i "s/index.html/index.php/g" /etc/apache2/httpd.conf
RUN echo "exec /usr/sbin/httpd -D FOREGROUND -f /etc/apache2/httpd.conf">> /usr/local/bin/docker-run-alt
RUN chmod +x /usr/local/bin/docker-run-alt

EXPOSE 80

WORKDIR /usr/local/bin
ENTRYPOINT ["docker-run"]


FROM alpine

WORKDIR /var/www/localhost/htdocs

RUN apk add --no-cache \
  php7 \
  php7-xml \
  php7-pdo \
  php7-pdo_mysql \
  php7-openssl \
  php7-zip \
  php7-tokenizer \
  php7-redis \
  php7-mbstring \
  php7-json \
  php7-xml \
  php7-apache2 \
  php7-curl \
  php7-phar \
  php7-dom \
  php7-xmlwriter \
  php7-ctype \
  php7-iconv \
  apache2

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ADD httpd.conf /etc/apache2

RUN mkdir -p /run/apache2

ONBUILD ADD . /var/www/localhost/htdocs
ONBUILD RUN php composer install --no-dev
ONBUILD RUN chmod 777 -R /var/www/localhost/htdocs/storage

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]


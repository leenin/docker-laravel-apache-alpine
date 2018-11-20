FROM alpine

WORKDIR /var/www/localhost/htdocs

RUN apk add --no-cache \
  curl \
  php7 \
  php7-gd \
  php7-pdo \
  php7-pdo_mysql \
  php7-openssl \
  php7-zip \
  php7-tokenizer \
  php7-redis \
  php7-mbstring \
  php7-json \
  php7-xml \
  php7-xmlrpc \
  php7-apache2 \
  php7-curl \
  php7-fileinfo \
  php7-phar \
  php7-dom \
  php7-xmlwriter \
  php7-xmlreader \
  php7-simplexml \
  php7-ctype \
  php7-iconv \
  php7-zlib \
  php7-opcache \
  apache2

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/bin/ --filename=composer

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ADD httpd.conf /etc/apache2

RUN mkdir -p /run/apache2

ONBUILD COPY composer.json /var/www/localhost/htdocs
ONBUILD COPY composer.lock /var/www/localhost/htdocs
ONBUILD RUN composer install --no-scripts --no-autoloader --no-dev
ONBUILD COPY . /var/www/localhost/htdocs
ONBUILD RUN composer dumpautoload
ONBUILD RUN chown apache:apache -R /var/www/localhost/htdocs/storage /var/www/localhost/htdocs/bootstrap/cache
ONBUILD RUN touch /var/www/localhost/htdocs/storage/logs/laravel.log
ONBUILD RUN chmod 777 /var/www/localhost/htdocs/storage/logs/laravel.log

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]


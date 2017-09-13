FROM alpine

RUN ln -s /var/www/localhost/htdocs /app

WORKDIR /app

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
  openrc \
  apache2

ADD httpd.conf /etc/apache2

ONBUILD ADD . /app
ONBUILD RUN php composer install

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]


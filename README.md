# docker-php-7-2-alpine

## description
Alpine PHP Docker Image with the following additional libraries:
* bcmath
* gd
* iconv
* imagick
* intl
* json
* mbstring
* memcached
* opcache
* pdo
* pdo_mysql
* redis
* simplexml
* soap
* sockets
* tokenizer
* xml
* yaml
* zip

## example service
```
version: '3.2'
services:
  fpm:
    image: 'iforgot/alpine-php:latest'
    volumes:
      - /local/php.ini:/path/to/php.ini
      - /local/sessions:/path/to/sessions
      - /local/www:/path/to/webroot
    restart: always
```

FROM php:7.2-fpm-alpine

RUN docker-php-source extract && \
# dependencies
apk add --no-cache --virtual .build-deps zlib-dev icu-dev yaml-dev gcc g++ libtool make freetype-dev libpng-dev libjpeg-turbo-dev imagemagick-dev libxml2-dev libmemcached-dev cyrus-sasl-dev && \
  apk add --no-cache --virtual .runtime-deps imagemagick autoconf freetype libpng libxml2 libjpeg-turbo icu yaml libmemcached-libs zlib rsync openssh-client && \
  apk add --no-cache php7-xdebug --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
  export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" && \
  # pecl extensions
  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  pecl install redis && \
  docker-php-ext-enable redis && \
  pecl install yaml && \
  docker-php-ext-enable yaml && \
  pecl install igbinary && \
  ( \
    pecl install --nobuild memcached && \
    cd "$(pecl config-get temp_dir)/memcached" && \
    phpize && \
    ./configure --enable-memcached-igbinary && \
    make -j$(nproc) && \
    make install && \
    cd /tmp/ \
  ) && \
  docker-php-ext-enable igbinary && \
  docker-php-ext-enable memcached && \
  pecl install imagick-3.4.3 && \
  # out-of-the-box extensions
  docker-php-ext-enable imagick && \
  docker-php-ext-install bcmath && \
  docker-php-ext-install iconv && \
  docker-php-ext-configure intl && \
  docker-php-ext-install intl && \
  docker-php-ext-install json && \
  docker-php-ext-install mbstring && \
  docker-php-ext-install opcache && \
  docker-php-ext-install pdo && \
  docker-php-ext-install pdo_mysql && \
  docker-php-ext-install simplexml && \
  docker-php-ext-install soap && \
  docker-php-ext-install sockets && \
  docker-php-ext-install tokenizer && \
  docker-php-ext-install xml && \
  docker-php-ext-install zip && \
  # clean up
  apk del .build-deps && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* && \
  docker-php-source delete

CMD ["php-fpm", "--allow-to-run-as-root"]
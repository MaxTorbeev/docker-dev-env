ARG PHP_VERSION=7.3
ARG APCU_VERSION=5.1.19

FROM php:${PHP_VERSION}-fpm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
    build-essential \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg-dev \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libicu-dev \
    libmemcached-dev \
    memcached \
    default-mysql-client \
    libmagickwand-dev \
    unzip \
    libzip-dev \
    zip \
    curl \
    git \
    tmux \
    openssh-client \
    wget \
    python3-pyqt5 \
    python3-pyqt5.qtwebengine \
#    libheif-examples \
    supervisor

# Install extensions

# mcrypt
#RUN pecl install mcrypt-1.0.4
#RUN docker-php-ext-enable mcrypt

# configure, install and enable all php packages
RUN docker-php-ext-configure gd
#--with-gd \
#                                --with-jpeg-dir \
#                                --with-png-dir \
#                                --with-webp-dir \
#                                --with-png-dir \
#                                --with-zlib-dir

RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure zip
RUN docker-php-ext-configure bcmath

RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) bcmath

# install xdebug
#RUN pecl install xdebug
#RUN docker-php-ext-enable xdebug

#RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.default_enable=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_log=\"/tmp/xdebug.log\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# configure opcache
RUN echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN echo "opcache.max_accelerated_files=4000" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN echo "opcache.revalidate_freq=2" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/conf.d/opcache-recommended.ini

# install imagick
RUN pecl install imagick-3.4.4
RUN docker-php-ext-enable imagick

# install composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.10.19

RUN curl --silent --show-error "https://getcomposer.org/installer" | php -- --install-dir=/usr/local/bin --filename=composer

# clean image
RUN apt-get clean

#ENTRYPOINT ["/usr/local/bin/php", "/var/www/apps/b2b/artisan", "websockets:serve"]

COPY docker/supervisord/websockets.conf /etc/supervisor/conf.d/websockets.conf

## Expose port 9000 and start php-fpm server
#EXPOSE 9000

CMD ["php-fpm"]

# ENTRYPOINT ["/usr/bin/supervisord"] does not work.
# --> "Error: positional arguments are not supported"
# http://stackoverflow.com/questions/22465003/error-positional-arguments-are-not-supported
#CMD ["/usr/bin/supervisord"]

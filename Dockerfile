ARG PHP_VERSION=7.3

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
    vim \
    tmux \
    openssh-client \
    wget \
    python3-pyqt5 \
    python3-pyqt5.qtwebengine \
    supervisor

# Clear out the local repository of retrieved package files
RUN apt-get clean

# Install extensions
# configure, install and enable all php packages
RUN docker-php-ext-configure gd
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
RUN curl --silent --show-error "https://getcomposer.org/installer" | php -- --install-dir=/usr/local/bin --filename=composer

# clean image
RUN apt-get clean

COPY docker/supervisord/websockets.conf /etc/supervisor/conf.d/websockets.conf

CMD ["php-fpm"]

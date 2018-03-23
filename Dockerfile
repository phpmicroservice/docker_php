#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php:71_phalcon_apache
#

FROM php:7.1.11-apache

MAINTAINER Dongasai 1514582970@qq.com

RUN a2enmod rewrite
RUN apt-get update;
RUN apt-get install -y vim wget;
ENV PHALCON_VERSION=3.1.2
ENV IM_VERSION=6.9.9-34

RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}

RUN docker-php-ext-install pdo pdo_mysql;docker-php-ext-enable pdo pdo_mysql;
RUN pecl install redis-3.1.6 \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable redis xdebug
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.0.4\
    && docker-php-ext-enable memcached
RUN docker-php-ext-install bcmath;
RUN apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install mbstring

COPY default.conf /etc/apache2/sites-enabled/000-default.conf

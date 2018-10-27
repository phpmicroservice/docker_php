#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php:71_phalcon_apache
#

FROM php:7.2.9-apache

MAINTAINER Dongasai 1514582970@qq.com

RUN a2enmod rewrite
RUN apt-get update;
RUN apt-get install -y git vim wget zip zlib1g-dev;
# 安装常用扩展
RUN docker-php-ext-install pdo pdo_mysql;docker-php-ext-enable pdo pdo_mysql;
RUN pecl install redis-4.0.2 \
    && docker-php-ext-enable redis
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.0.4\
    && docker-php-ext-enable memcached
RUN docker-php-ext-install bcmath;
RUN docker-php-ext-install zip;
RUN apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mbstring
# 安装 composer
RUN curl -sS https://getcomposer.org/installer | php;mv composer.phar /usr/local/bin/composer
# 安装phalcon 3.1.2版本,这是7.1版本php可安装的最高版本
ENV PHALCON_VERSION=3.4.1
RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}
	
COPY default.conf /etc/apache2/sites-enabled/000-default.conf

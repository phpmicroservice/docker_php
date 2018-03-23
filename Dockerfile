#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php:71_phalcon_apache
#

FROM php:7.1.11-cli

MAINTAINER Dongasai 1514582970@qq.com

RUN apt-get update;
RUN apt-get install -y vim wget;
# 安装常用扩展
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
# 安装swoole 2.1.1版本 
ENV SWOOLE_VERSION 2.1.1
RUN pecl install swoole-${SWOOLE_VERSION}
# 安装phalcon 3.1.2版本,这是7.1版本php可安装的最高版本
ENV PHALCON_VERSION=3.1.2
RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}

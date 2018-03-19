#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php
#

FROM library/php:5.4.40-apache

MAINTAINER Dongasai 1514582970@qq.com
ENV SWOOLE_VERSION=2.1.1
RUN apt-get update;
RUN apt-get install -y vim wget;
RUN docker-php-ext-install mysql;docker-php-ext-enable mysql;
RUN docker-php-ext-install bcmath;
RUN apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install mbstring
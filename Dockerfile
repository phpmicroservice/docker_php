#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php
#

FROM library/php:5.6.37-apache

MAINTAINER Dongasai 1514582970@qq.com
ENV SWOOLE_VERSION=2.1.1
RUN apt-get update;
RUN apt-get install -y git vim wget;
# 安装常用扩展
RUN docker-php-ext-install mysql
RUN docker-php-ext-install bcmath
RUN apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mbstring zip

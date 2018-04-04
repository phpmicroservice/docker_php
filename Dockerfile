#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php:71_phalcon_apache
#

FROM php:7.1.11-cli

MAINTAINER Dongasai 1514582970@qq.com

RUN apt-get update;
RUN apt-get install -y git vim wget;
# 安装常用扩展
RUN docker-php-ext-install pdo pdo_mysql;docker-php-ext-enable pdo pdo_mysql;
RUN docker-php-ext-install bcmath;
RUN docker-php-ext-install zip
RUN docker-php-ext-install mbstring
RUN pecl install redis-3.1.6 \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable redis xdebug
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.0.4\
    && docker-php-ext-enable memcached
RUN apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd

# 安装 composer
RUN curl -sS https://getcomposer.org/installer | php;mv composer.phar /usr/local/bin/composer;composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 安装 swoole 
ENV SWOOLE_VERSION 2.1.1
RUN pecl install swoole-${SWOOLE_VERSION};docker-php-ext-enable swoole;

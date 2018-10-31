#
# php-Microservice 7.1 Dockerfile
#
# phpmicroservice/docker_php:71_phalcon_apache
#

FROM php:7.1.18-cli

MAINTAINER Dongasai 1514582970@qq.com

RUN apt-get update;
RUN apt-get install -y git vim wget zip zlib1g-dev;
# 安装常用扩展
RUN docker-php-ext-install pdo pdo_mysql;docker-php-ext-enable pdo pdo_mysql;
RUN docker-php-ext-install bcmath;
RUN docker-php-ext-install zip
RUN docker-php-ext-install mbstring
RUN apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd
	
RUN pecl install redis-4.1.1 && docker-php-ext-enable redis 
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.0.4\
    && docker-php-ext-enable memcached
# pecl install inotify
RUN pecl install inotify-2.0.0\
    && docker-php-ext-enable inotify

# 安装 composer
RUN curl -sS https://getcomposer.org/installer | php;mv composer.phar /usr/local/bin/composer;composer global require hirak/prestissimo
# 安装swoole 2.1.1版本 
ENV SWOOLE_VERSION 2.2.0
RUN pecl install swoole-${SWOOLE_VERSION};docker-php-ext-enable swoole;
# 安装phalcon 3.1.2版本,这是7.1版本php可安装的最高版本
ENV PHALCON_VERSION=3.1.2
RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}

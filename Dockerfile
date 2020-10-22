FROM centos:7

# Add repository and keys
RUN yum -y update
RUN yum -y install epel-release

# Install httpd
RUN yum -y install httpd
RUN yum -y install httpd mod_ssl

# Copy apache conf
COPY .docker/sample_project.conf /etc/httpd/conf.d/sample_project.conf

# Install PHP 5
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php56
RUN yum -y install openssl 
RUN yum -y install php
RUN yum -y install php-xml php-common php-mbstring php-gd php-mcrypt php-cli \
                   php-pdo php-mysql php-zip php-tokenizer php-pear php-pecl-memcache

RUN yum -y install libevent libevent-devel
RUN yum -y install php5-memcached memcached
RUN yum -y install libmemcached

COPY .docker/memcached.conf /etc/memcached.conf
COPY .docker/memcached /etc/sysconfig/memcached

RUN yum -y install initscripts && yum clean all

# PHP-FPM needs this folder
RUN mkdir -p /run/php-fpm

# RUN pecl install memcached-2.2.0
# RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# Install pip
RUN yum -y install python-pip
RUN pip install --upgrade pip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x
RUN yum -y install nodejs

# install git
RUN yum -y install git

# Install supervisor
RUN pip install supervisor

# Copy supervisor conf
COPY .docker/supervisord.conf /etc/supervisord.conf

# Copy source code
#COPY src /workspace
WORKDIR /var/www/html

# Set folder permissions
# See: https://laracasts.com/discuss/channels/general-discussion/laravel-framework-file-permission-security
#RUN chgrp -R apache /workspace/storage /workspace/bootstrap/cache
#RUN chmod -R ug+rwx /workspace/storage /workspace/bootstrap/cache

# Add start script
COPY .docker/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80
EXPOSE 443

CMD ["/start.sh"]
FROM alpine:latest

ENV TERM="xterm" \
    DB_HOST="localhost" \
    DB_NAME="wordpress" \
    DB_USER="admin"\
    DB_PASS="banana"

RUN apk add --no-cache bash curl less  nginx ca-certificates git tzdata zip \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    php7-fpm php7-json php7-zlib php7-xml php7-pdo php7-phar php7-openssl \
    php7-pdo_mysql php7-mysqli php7-session \
    php7-gd php7-iconv php7-mcrypt php7-gmp php7-zip \
    php7-curl php7-opcache php7-ctype php7-apcu \
    sudo \
    mariadb mariadb-server-utils \
    php7-intl php7-bcmath php7-dom php7-mbstring php7-xmlreader mysql-client curl && apk add -u musl && \
    rm -rf /var/cache/apk/*

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 4096M/g' /etc/php7/php.ini && \ 
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php7/
ADD scripts/run.sh /
ADD scripts/mysql_setup.sql /
ADD scripts/mysql_user.sql /
RUN chmod +x /run.sh && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp && chown nginx:nginx /usr/bin/wp

# allow nginx user run WP-CLI commands
RUN echo 'root ALL=(nginx) NOPASSWD: /usr/local/bin/wp' >> /etc/sudoers
# prevent warning when running sudo
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# mariadb setup
RUN mkdir -p /run/mysqld 

RUN mysql_install_db --user=root --basedir=/usr --datadir=/var/lib/mysql 

# create WP database
RUN /usr/bin/mysqld --user=root --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < /mysql_setup.sql

RUN mkdir -p /usr/html
RUN echo '<?php echo "hello"; ' > /usr/html/index.php
RUN chown -R nginx:www-data /usr/html/
RUN cd /usr/html && sudo -u nginx wp core download
RUN ls

EXPOSE 2000-8000
#VOLUME ["/usr/html"]

CMD ["/run.sh"]

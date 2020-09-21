FROM alpine:latest

ENV TERM="xterm"

RUN apk add --no-cache bash curl less nginx ca-certificates tzdata zip curl \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev  libpng-dev \
    php7-fpm php7-json php7-zlib php7-xml  php7-phar php7-openssl \
    php7-mysqli php7-session \
    php7-gd php7-iconv php7-mcrypt php7-gmp php7-zip \
    php7-curl php7-opcache php7-ctype php7-apcu php7-ftp php7-tokenizer php7-simplexml \
    sudo vim tmux git procps wget sed grep openssh-keygen \
    mariadb mariadb-server-utils mysql-client \
    php7-intl php7-bcmath php7-dom php7-mbstring php7-xmlreader  && apk add -u musl && \
    rm -rf /var/cache/apk/*

# removed
#  libjpeg-turbo-dev php7-pdo php7-pdo_mysql git 

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = -1/g' /etc/php7/php.ini && \ 
    sed -i 's/max_execution_time = 30/max_execution_time = 0/g' /etc/php7/php.ini && \ 
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php7/
ADD conf/.vimrc /root/
ADD conf/.tmux.conf /root/
ADD scripts/run.sh /
ADD scripts/backup_site.sh /
ADD installers /installers
ADD scripts/mysql_setup.sql /
ADD scripts/mysql_user.sql /
ADD scripts/mysql_user.sql /
ADD scripts/install_default_plugins.sh /
RUN chmod +x /run.sh && \
    chmod +x /backup_site.sh && \
    chmod +x /installers/wp-cli.phar && mv installers/wp-cli.phar /usr/bin/wp && chown nginx:nginx /usr/bin/wp

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

WORKDIR /usr/html
# extract WordPress to web root
RUN unzip /installers/wordpress-5.5.zip -d /tmp
RUN cp -r /tmp/wordpress/* /usr/html/
RUN rm -Rf /tmp/wordpress

# install all default plugins
RUN sh /install_default_plugins.sh
# cleanup
RUN rm -Rf /installers

# set web root permissions
RUN chown -R nginx:www-data /usr/html/

EXPOSE 4000-5000
# EXPOSE 4444
#VOLUME ["/usr/html"]

CMD ["/run.sh"]

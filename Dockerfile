FROM alpine:edge

ENV TERM="xterm"
# allow phpMyAdmin auto-login
# ENV PMA_USER="root"
# ENV PMA_PASSWORD="banana"

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bash curl less nginx ca-certificates tzdata zip curl \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev  libpng-dev \
    php8-fpm php8-json php8-zlib php8-xml  php8-phar php8-openssl \
    php8-mysqli php8-session \
    php8-gd php8-iconv php8-gmp php8-zip php8-fileinfo \
    php8-curl php8-opcache php8-ctype php8-ftp php8-tokenizer php8-simplexml \
    sudo vim tmux git procps wget sed grep openssh-keygen \
    mariadb mariadb-server-utils mysql-client \
    php8-intl php8-bcmath php8-dom php8-mbstring php8-xmlreader php8-xmlwriter && apk add -u musl && \
    rm -rf /var/cache/apk/*

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    composer && \
    rm -rf /var/cache/apk/*

# RM PHP7 and link PHP8 after composer install
RUN rm /usr/bin/php && \
    ln -s /usr/bin/php8 /usr/bin/php

# NOTE: not found since 7 > 8 upgrade: php8-apcu php8-mcrypt 

# removed
#  libjpeg-turbo-dev php8-pdo php8-pdo_mysql 

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php8/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = -1/g' /etc/php8/php.ini && \ 
    sed -i 's/max_execution_time = 30/max_execution_time = 0/g' /etc/php8/php.ini && \ 
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php8/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    # dubious about this one - seems to have been fine without
    ln -s /sbin/php-fpm8 /sbin/php-fpm

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php8/
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
RUN unzip /installers/wordpress-5.6-RC5.zip -d /tmp
RUN cp -r /tmp/wordpress/* /usr/html/
RUN rm -Rf /tmp/wordpress

# extract phpMyAdmin to /usr/html/phpmyadmin/
RUN unzip /installers/phpMyAdmin-5.0.2-all-languages.zip -d /tmp
RUN mv /tmp/phpMyAdmin-5.0.2-all-languages /usr/html/phpmyadmin/
RUN rm -Rf /tmp/phpMyAdmin-5.0.2-all-languages

# allow autologin for phpmyadmin
RUN mv /usr/html/phpmyadmin/config.sample.inc.php /usr/html/phpmyadmin/config.inc.php
RUN echo "\$cfg['Servers'][\$i]['auth_type'] = 'config';" >> /usr/html/phpmyadmin/config.inc.php
RUN echo "\$cfg['Servers'][\$i]['username'] = 'root';" >> /usr/html/phpmyadmin/config.inc.php
RUN echo "\$cfg['Servers'][\$i]['password'] = 'banana';" >> /usr/html/phpmyadmin/config.inc.php


# show user/pwd hint on login screen
RUN grep -Rl 'Username or Email Address' | xargs sed -i 's/Username or Email Address/User (u\/p: admin\/admin)/g'

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

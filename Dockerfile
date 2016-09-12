FROM php:5-apache
MAINTAINER Patrick Gunzelmann "patrick@gunzelmann.com"

EXPOSE 80

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        ssmtp \
        imagemagick \
    && echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli opcache

RUN a2enmod rewrite

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    441276E9CCD15F44F6D97D18C119E1A64D70938E \
    41B2ABE817ADD3E52BDA946F72BC1C5D23107F8A \
    162432D9E81C1C618B301EECEE1F663462D84F01 \
    1D98867E82982C8FE0ABC25F9B69B3109D3BB7B0 \
    3CEF8262806D3F0B6BA1DBDD7956EE477F901A30 \
    280DB7845A1DCAC92BB5A00A946B02565DC00AA7

ADD get-mediawiki.sh /tmp/get-mediawiki.sh

RUN set -x; \
    /tmp/get-mediawiki.sh latest \
    && gpg --verify /tmp/mediawiki.tar.gz.sig \
    && tar -xf /tmp/mediawiki.tar.gz -C /var/www/html --strip-components=1 \
    && rm -rf /tmp/get-mediawiki.sh /tmp/mediawiki.tar.gz*

RUN chown -R www-data:www-data /var/www/html/

COPY mediawiki-apache.conf /etc/apache2/mediawiki.conf
RUN echo "Include /etc/apache2/mediawiki.conf" >> /etc/apache2/apache2.conf

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]

VOLUME ["/var/www/html/images"]
VOLUME ["/var/www/html/extensions"]

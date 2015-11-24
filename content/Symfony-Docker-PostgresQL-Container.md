+++
date = "2015-10-26T21:58:00+11:00"
draft = false
title = "Symfony Docker PostgresQL Container"

+++

## Compose Config

Using Compose using data only containers for cache and logs

```
main:
  build: .
  volumes:
    - .:/var/www/mysite
  volumes_from:
    - data_cache
    - data_logs
  ports:
    - 1082:80
data_cache:
  image: php:5.6-apache
  volumes:
    - /var/www/sixpence-collection/app/cache
  command: chown -R www-data.www-data /var/www/mysite/app/cache
data_logs:
  image: php:5.6-apache
  volumes:
    - /var/www/sixpence-collection/app/logs
  command: chown -R www-data.www-data /var/www/mysite/app/logs
```

Using the same image as the main container prevents downloading and storing another image reducing build time and storage, Replace the command to prevent running apache and also update the owner and group for the cache and log files. 

# Dockerfile

Enable rewite and install PDO Postgres driver

```
FROM php:5.6-apache
#COPY . /var/www/mysite

RUN a2enmod rewrite && \
    apt-get update && apt-get install -y libpq-dev && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install pdo pdo_pgsql

COPY server-config/apache.conf /etc/apache2/sites-enabled/mysite.conf

COPY server-config/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/mysite
```

## PHP Config

Set the PHP datetime

```
[PHP]


[Date]
date.timezone = Australia/Melbourne
```

## Apache Config

Configure the Virtual Host

```
<VirtualHost *:80>
	ServerAdmin webmaster@rain.com.au
	DocumentRoot /var/www/mysite/web
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined

	<Directory /var/www/mysite/web>
        AllowOverride None
        Require all granted

        <IfModule mod_rewrite.c>
            RewriteRule / app_dev.php [QSA,L]
            Options -MultiViews
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ app_dev.php [QSA,L]
        </IfModule>
    </Directory>
</VirtualHost>
```

## Console Access

Get container name using ps then connect using exec

```
docker ps
docker exec -i -t CONTAINER_NAME bash
```

## Add a Database

```
db:
  image: postgres:9.4
  volumes_from:
      - data_db
  expose:
    - 5432
data_db:
  image: postgres:9.4
  volumes:
    - /var/lib/postgresql/data
  command: ls /var/lib/postgresql/data
```

## Parameters.yml

```
    database_host: mysite_db_1
    database_port: null
    database_name: my_site
    database_user: postgres
    database_password: null
```

## Create DB, Entities and CRUD

```
./app/console doctrine:database:create
./app/console doctrine:generate:entity
./app/console doctrine:generate:crud

```






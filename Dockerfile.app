FROM php:7.2-fpm

# Copy composer.json
COPY composer.json /var/www/

# Set working dir
WORKDIR /var/www

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    mariadb-client-10.3 \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /var/www

# Add non-sudo user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www
COPY --chown=www:www . /var/www
USER www

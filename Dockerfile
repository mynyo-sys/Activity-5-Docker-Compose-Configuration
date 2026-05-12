FROM php:8.5.4-cli

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    zip \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    zip \
    intl \
    xml \
    pdo \
    pdo_mysql \
    mbstring

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . .

# Install composer dependencies
RUN composer install --no-interaction --optimize-autoloader

# Create necessary directories with proper permissions
RUN mkdir -p var/cache var/log && \
    chmod -R 777 var/

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
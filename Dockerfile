# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04
#dummy comment

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and PHP modules
RUN apt update && apt upgrade -y && \
    apt install -y apache2 php libapache2-mod-php \
    php-mysql php-gd php-xml php-mbstring php-curl php-zip php-intl php-bcmath php-imagick \
    unzip rsync sudo && \
    apt clean

# Create the Nextcloud web root
RUN mkdir -p /var/www/html/nextcloud

# Copy the Nextcloud zip file into the image
COPY nextcloud-27.1.7.zip /tmp/nextcloud.zip

# Extract and move files to /var/www/html/nextcloud (including hidden ones)
WORKDIR /var/www/html/nextcloud
RUN unzip /tmp/nextcloud.zip && \
    rm /tmp/nextcloud.zip && \
    rsync -a nextcloud/ . && \
    rm -rf nextcloud

# Copy Apache virtual host configuration
COPY nextcloud.conf /etc/apache2/sites-available/000-default.conf

# Copy the cert over
COPY zscaler.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Set correct ownership for Apache
RUN chown -R www-data:www-data /var/www/html/nextcloud

# Enable required Apache modules
RUN a2enmod rewrite headers env dir mime

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 80
EXPOSE 80

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]


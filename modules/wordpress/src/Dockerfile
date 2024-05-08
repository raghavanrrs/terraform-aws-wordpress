# Use the Bitnami WordPress image as base
FROM bitnami/wordpress:latest

# Install WP Offload Media plugin using Composer
#RUN mkdir /tmp/wp-cli-packages && cd /tmp/wp-cli-packages 
#COPY composer.json /tmp/wp-cli-packages/composer.json
#RUN /opt/bitnami/php/bin/composer require --no-cache deliciousbrains-plugin/wp-offload-media -d /tmp/wp-cli-packages && /opt/bitnami/wp-cli/bin/wp #plugin activate wp-offload-media

#RUN wp plugin install wp-offload-media
#RUN wp plugin install offload-media-cloud-storage --activate


# Add configuration to wp-config.php
RUN echo "\n\
/* WP Offload Media Configuration */\n\
define('AS3CF_SETTINGS', serialize(array(\n\
    'provider' => 'aws',\n\
    'bucket' => getenv('MEDIA_S3_BUCKET_NAME'),\n\
)));" >> /opt/bitnami/wordpress/wp-config.php

ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
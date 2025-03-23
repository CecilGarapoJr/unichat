#!/bin/bash

# Script to update SMTP configuration for UniChat

# Enter the Docker container and update the environment variables
docker exec -it unichat10copy-rails-1 /bin/sh -c "
  echo 'Updating SMTP configuration...'
  export MAILER_SENDER_EMAIL='UniChat <unichat@digitalgrowth.global>'
  export SMTP_DOMAIN=digitalgrowth.global
  export SMTP_ADDRESS=c105494.sgvps.net
  export SMTP_PORT=465
  export SMTP_USERNAME=unichat@digitalgrowth.global
  export SMTP_PASSWORD='9wD3i+c3\$1^#'
  export SMTP_AUTHENTICATION=plain
  export SMTP_ENABLE_STARTTLS_AUTO=false
  export SMTP_SSL=true
  export MAILER_INBOUND_EMAIL_DOMAIN=digitalgrowth.global
  export RAILS_INBOUND_EMAIL_SERVICE=relay
  
  # Update the Rails configuration
  bin/rails runner \"
    puts 'Updating SMTP settings in Rails...'
    ActionMailer::Base.smtp_settings = {
      address: 'c105494.sgvps.net',
      port: 465,
      domain: 'digitalgrowth.global',
      user_name: 'unichat@digitalgrowth.global',
      password: '9wD3i+c3\\\$1^#',
      authentication: :plain,
      enable_starttls_auto: false,
      ssl: true
    }
    puts 'SMTP settings updated successfully!'
  \"
  
  # Clear cache to apply changes
  bin/rails runner \"GlobalConfig.clear_cache\"
  
  echo 'SMTP configuration updated successfully!'
"

echo "SMTP configuration update script completed!"

#!/bin/bash

# Script to create a package of UniChat branding changes
# After running this, you'll have a zip file to upload to your server

echo "Creating UniChat branding package..."

# Create temporary directory structure
rm -rf unichat-branding
mkdir -p unichat-branding/logos
mkdir -p unichat-branding/config

# Copy logo files
cp public/brand-assets/logo.svg unichat-branding/logos/
cp public/brand-assets/logo_dark.svg unichat-branding/logos/
cp public/brand-assets/logo_thumbnail.svg unichat-branding/logos/
cp app/javascript/dashboard/assets/images/bubble-logo.svg unichat-branding/logos/
cp app/javascript/widget/assets/images/logo.svg unichat-branding/logos/widget-logo.svg

# Copy localization files
cp config/locales/en.yml unichat-branding/config/
cp config/locales/devise.en.yml unichat-branding/config/

# Create SMTP configuration
cat > unichat-branding/smtp_settings.env << EOF
SMTP_ADDRESS=c105494.sgvps.net
SMTP_PORT=465
SMTP_USERNAME=unichat@digitalgrowth.global
SMTP_PASSWORD=9wD3i+c3$1^#
SMTP_DOMAIN=digitalgrowth.global
SMTP_ENABLE_STARTTLS_AUTO=true
SMTP_AUTHENTICATION=login
SMTP_OPENSSL_VERIFY_MODE=none
EOF

# Create instructions for applying changes
cat > unichat-branding/README.md << EOF
# UniChat Branding Changes

## How to Apply

1. Upload this directory to your server
2. Find your running Chatwoot container:
   \`\`\`
   docker ps | grep chatwoot
   \`\`\`

3. Copy the files to the container:
   \`\`\`
   docker cp unichat-branding/logos/. CONTAINER_ID:/app/public/brand-assets/
   docker cp unichat-branding/logos/bubble-logo.svg CONTAINER_ID:/app/app/javascript/dashboard/assets/images/
   docker cp unichat-branding/logos/widget-logo.svg CONTAINER_ID:/app/app/javascript/widget/assets/images/logo.svg
   docker cp unichat-branding/config/. CONTAINER_ID:/app/config/locales/
   \`\`\`

4. Apply SMTP settings:
   \`\`\`
   docker exec -it CONTAINER_ID bash
   cat > /app/.env.production.local << EOF
   $(cat unichat-branding/smtp_settings.env)
   EOF
   exit
   \`\`\`

5. Restart the container:
   \`\`\`
   docker restart CONTAINER_ID
   \`\`\`
EOF

# Create zip file
zip -r unichat-branding.zip unichat-branding

echo "Package created: unichat-branding.zip"
echo "Upload this file to your server and follow the instructions in README.md"

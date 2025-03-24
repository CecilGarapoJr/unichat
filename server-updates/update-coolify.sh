#!/bin/bash

# Get container ID of the Rails application
CONTAINER_ID=$(docker ps -qf "name=rails")

if [ -z "$CONTAINER_ID" ]; then
    echo "Error: Rails container not found"
    exit 1
fi

# Create directories for our changes
mkdir -p server-updates/brand-assets
mkdir -p server-updates/dashboard
mkdir -p server-updates/widget
mkdir -p server-updates/locales

# Copy files to update
cp ../public/brand-assets/logo*.svg server-updates/brand-assets/
cp ../app/javascript/dashboard/assets/images/bubble-logo.svg server-updates/dashboard/
cp ../app/javascript/widget/assets/images/logo.svg server-updates/widget/
cp ../config/locales/en.yml ../config/locales/devise.en.yml server-updates/locales/

# Copy files to container
echo "Copying branding files to container $CONTAINER_ID..."
docker cp server-updates/brand-assets $CONTAINER_ID:/app/public/
docker cp server-updates/dashboard/bubble-logo.svg $CONTAINER_ID:/app/app/javascript/dashboard/assets/images/
docker cp server-updates/widget/logo.svg $CONTAINER_ID:/app/app/javascript/widget/assets/images/
docker cp server-updates/locales/en.yml $CONTAINER_ID:/app/config/locales/
docker cp server-updates/locales/devise.en.yml $CONTAINER_ID:/app/config/locales/

# Create update script to run inside the container
cat > server-updates/update-branding.sh << 'EOF'
#!/bin/bash
cd /app

# Update title and other branding in JavaScript files
find ./app/javascript -type f -name "*.js" -o -name "*.vue" | xargs sed -i 's/Chatwoot/UniChat/g'

# Clear asset cache and precompile assets
bundle exec rake assets:clobber
bundle exec rake assets:precompile

# Restart the application to apply changes
bin/rails restart
EOF

# Make the script executable
chmod +x server-updates/update-branding.sh

# Copy and run the script in the container
echo "Copying and running update script in container..."
docker cp server-updates/update-branding.sh $CONTAINER_ID:/app/
docker exec $CONTAINER_ID bash -c 'chmod +x /app/update-branding.sh && /app/update-branding.sh'

echo "UniChat branding update completed!"

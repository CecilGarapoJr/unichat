#!/bin/bash

# Function to backup a file before modifying it
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        cp "$file" "${file}.bak"
        echo "Backed up $file"
    fi
}

# Function to restore SMTP settings
setup_smtp() {
    local config_file="/app/config/application.yml"
    backup_file "$config_file"
    
    cat >> "$config_file" << EOF
# SMTP Configuration
SMTP_ADDRESS: c105494.sgvps.net
SMTP_PORT: 465
SMTP_USERNAME: unichat@digitalgrowth.global
SMTP_PASSWORD: "9wD3i+c3$1^#"
SMTP_DOMAIN: digitalgrowth.global
SMTP_ENABLE_STARTTLS_AUTO: true
SMTP_AUTHENTICATION: login
SMTP_OPENSSL_VERIFY_MODE: none
EOF

    echo "SMTP settings updated"
}

# Function to update logos
update_logos() {
    local brand_dir="/app/public/brand-assets"
    local dashboard_dir="/app/app/javascript/dashboard/assets/images"
    local widget_dir="/app/app/javascript/widget/assets/images"
    
    # Backup existing logos
    backup_file "$brand_dir/logo.svg"
    backup_file "$brand_dir/logo_dark.svg"
    backup_file "$brand_dir/logo_thumbnail.svg"
    backup_file "$dashboard_dir/bubble-logo.svg"
    backup_file "$widget_dir/logo.svg"
    
    # Copy new logos
    cp /tmp/brand-assets/* "$brand_dir/"
    cp /tmp/dashboard/bubble-logo.svg "$dashboard_dir/"
    cp /tmp/widget/logo.svg "$widget_dir/"
    
    echo "Logos updated"
}

# Function to remove dashboard help page
remove_dashboard_help() {
    local routes_file="/app/config/routes.rb"
    backup_file "$routes_file"
    
    # Comment out the help page route
    sed -i 's/^\(.*\)get.*dashboard\/help.*$/# \1/' "$routes_file"
    
    echo "Dashboard help page removed"
}

# Function to update localization
update_localization() {
    local locale_dir="/app/config/locales"
    backup_file "$locale_dir/en.yml"
    backup_file "$locale_dir/devise.en.yml"
    
    cp /tmp/locales/* "$locale_dir/"
    echo "Localization updated"
}

# Main execution
echo "Starting UniChat customization..."

# Create backup directory
mkdir -p /app/backups/$(date +%Y%m%d_%H%M%S)

# Apply changes
setup_smtp
update_logos
remove_dashboard_help
update_localization

# Restart the application
bundle exec rails restart

echo "All changes applied successfully!"

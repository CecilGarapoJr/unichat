#!/bin/bash

# Make the script executable
chmod +x coolify-deploy.sh

# Function to check if Coolify CLI is installed
check_coolify_cli() {
    if ! command -v coolify &> /dev/null; then
        echo "Installing Coolify CLI..."
        curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
    fi
}

# Initialize Coolify configuration
init_coolify() {
    echo "Initializing Coolify configuration..."
    coolify init
}

# Deploy the application
deploy() {
    echo "Deploying UniChat to Coolify..."
    
    # Load environment variables
    set -a
    source .env.coolify
    set +a
    
    # Deploy using docker-compose.coolify.yml
    coolify deploy
}

# Main script
case "$1" in
    "init")
        check_coolify_cli
        init_coolify
        ;;
    "deploy")
        deploy
        ;;
    *)
        echo "Usage: $0 {init|deploy}"
        echo "  init   - Initialize Coolify configuration"
        echo "  deploy - Deploy the application"
        exit 1
        ;;
esac

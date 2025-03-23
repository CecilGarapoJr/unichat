# UniChat Deployment Guide for Coolify

This guide provides step-by-step instructions for deploying UniChat to your server using Coolify.

## Prerequisites

- A server with Coolify installed
- Git repository with UniChat code
- Domain name (optional but recommended)

## Deployment Steps

### 1. Prepare Your Repository

Ensure your repository contains the following files:
- `docker-compose.coolify.yml` - Docker Compose configuration for Coolify
- `Dockerfile.production` - Production-ready Dockerfile
- `bin/docker-entrypoint` - Script to handle startup tasks
- `.env.coolify.example` - Template for environment variables

### 2. Create a New Resource in Coolify

1. Log in to your Coolify dashboard
2. Click "New Resource"
3. Select "Docker Compose" from the Docker Based options
4. Connect your Git repository containing the UniChat code

### 3. Configure the Deployment

1. **Repository Settings:**
   - Select the branch you want to deploy (e.g., `main` or `master`)
   - Set the Docker Compose file path to `docker-compose.coolify.yml`

2. **Environment Variables:**
   - Copy the variables from `.env.coolify.example` to Coolify's environment variables section
   - Update the following variables with your specific values:
     - `SECRET_KEY_BASE`: Generate with `openssl rand -hex 64`
     - `FRONTEND_URL`: Your domain (e.g., `https://unichat.yourdomain.com`)
     - `POSTGRES_PASSWORD`: A secure database password
     - `REDIS_PASSWORD`: A secure Redis password

3. **Port Configuration:**
   - Ensure port 3000 is exposed and mapped to your desired public port

4. **Domain Configuration (Optional but Recommended):**
   - Add your domain (e.g., `unichat.yourdomain.com`)
   - Enable HTTPS with Let's Encrypt

### 4. Deploy the Application

1. Click "Deploy" to start the deployment process
2. Coolify will build the Docker images and start the containers
3. The deployment process may take several minutes to complete

### 5. Post-Deployment Tasks

1. **Create Admin User:**
   - Connect to the Rails container using Coolify's terminal
   - Run the following command to create an admin user:
     ```
     bundle exec rails c
     ```
     ```ruby
     User.create!(
       name: "Admin User",
       email: "admin@yourdomain.com",
       password: "your-secure-password",
       role: "administrator",
       confirmed_at: Time.now
     )
     ```

2. **Verify Email Configuration:**
   - Test sending emails from the application
   - Ensure incoming emails are properly processed

### 6. Monitoring and Maintenance

1. **Logs:**
   - Monitor application logs through Coolify's dashboard

2. **Updates:**
   - To update UniChat, push changes to your repository and redeploy through Coolify

3. **Backups:**
   - Set up regular database backups using Coolify's backup feature

## Troubleshooting

### Common Issues

1. **Database Connection Issues:**
   - Verify database credentials in environment variables
   - Check if PostgreSQL container is running

2. **Email Configuration Issues:**
   - Verify SMTP settings in environment variables
   - Test email connectivity from the Rails container

3. **Application Not Starting:**
   - Check logs for error messages
   - Verify all required environment variables are set

### Getting Help

If you encounter issues not covered in this guide, you can:
- Check the application logs in Coolify
- Refer to the UniChat documentation
- Contact support for assistance

## Security Considerations

1. **Environment Variables:**
   - Use strong, unique passwords for database and Redis
   - Keep your `.env` file secure and never commit it to version control

2. **Network Security:**
   - Restrict access to your Coolify dashboard
   - Use HTTPS for all connections
   - Consider implementing IP restrictions for admin access

## Conclusion

You have successfully deployed UniChat to your server using Coolify. The application should now be accessible at your configured domain or IP address.

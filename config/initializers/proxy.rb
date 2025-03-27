# frozen_string_literal: true

# Configure Rails to trust certain proxy headers for proper HTTPS detection
Rails.application.config.after_initialize do
  # Get trusted proxy IPs from environment variable or use default Coolify network ranges
  trusted_proxies = ENV.fetch('TRUSTED_PROXIES', '172.16.0.0/12,192.168.0.0/16,10.0.0.0/8').split(',')
  
  if trusted_proxies.any?
    # Add the trusted proxy IPs to the existing proxy list
    Rails.application.config.action_dispatch.trusted_proxies =
      ActionDispatch::RemoteIp::TRUSTED_PROXIES +
      trusted_proxies.map { |proxy| IPAddr.new(proxy.strip) }
  end

  # Enable SSL in production
  if Rails.env.production?
    config = Rails.application.config
    
    # Force SSL unless explicitly disabled
    config.force_ssl = ActiveModel::Type::Boolean.new.cast(ENV.fetch('FORCE_SSL', true))
    
    # Trust X-Forwarded-Proto header
    config.action_controller.forgery_protection_origin_check = true
    config.ssl_options = { redirect: { exclude: -> request { request.path =~ /health_check/ } } }
  end

  # Set secure headers
  Rails.application.config.action_dispatch.default_headers.merge!(
    'X-Frame-Options' => 'SAMEORIGIN',
    'X-XSS-Protection' => '1; mode=block',
    'X-Content-Type-Options' => 'nosniff',
    'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains'
  )
end

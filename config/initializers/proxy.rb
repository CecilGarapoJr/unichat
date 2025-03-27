# frozen_string_literal: true

# Configure Rails to trust certain proxy headers for proper HTTPS detection
Rails.application.config.after_initialize do
  # Get trusted proxy IPs from environment variable
  trusted_proxies = ENV.fetch('TRUSTED_PROXIES', '').split(',')
  
  if trusted_proxies.any?
    # Add the trusted proxy IPs to the existing proxy list
    Rails.application.config.action_dispatch.trusted_proxies =
      ActionDispatch::RemoteIp::TRUSTED_PROXIES +
      trusted_proxies.map { |proxy| IPAddr.new(proxy.strip) }
  end

  # Trust the X-Forwarded-Proto header from our reverse proxy
  Rails.application.config.action_dispatch.default_headers.merge!(
    'X-Frame-Options' => 'SAMEORIGIN',
    'X-XSS-Protection' => '1; mode=block',
    'X-Content-Type-Options' => 'nosniff'
  )
end

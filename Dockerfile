# Use the official Ruby image as base
FROM ruby:3.1-slim

# Install essential packages and dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libvips \
    postgresql-client \
    nodejs \
    npm \
    libmagickwand-dev \
    imagemagick \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and pnpm
RUN npm install -g corepack@0.24.1 \
    && corepack enable \
    && corepack prepare pnpm@9.6.1 --activate

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install Ruby and Node.js dependencies
RUN gem update --system \
    && gem install bundler:2.4.22 \
    && bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle config set --local path 'vendor/bundle' \
    && bundle config set build.nokogiri --use-system-libraries \
    && bundle install --jobs=4 --retry=3 --clean \
    && pnpm install --frozen-lockfile --prefer-offline

# Precompile assets
RUN RAILS_ENV=production \
    NODE_ENV=production \
    SECRET_KEY_BASE=dummy \
    bundle exec rake assets:precompile

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Start the application
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

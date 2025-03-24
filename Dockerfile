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
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN npm install -g n && n 20

# Install pnpm
RUN npm install -g corepack@0.24.1 \
    && corepack enable \
    && corepack prepare pnpm@9.6.1 --activate

# Set working directory
WORKDIR /app

# Create necessary directories
RUN mkdir -p tmp/pids tmp/cache

# Copy package files first
COPY package.json pnpm-lock.yaml ./
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN gem update --system \
    && gem install bundler:2.4.22 \
    && bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle config set --local path 'vendor/bundle' \
    && bundle config set build.nokogiri --use-system-libraries \
    && bundle install --jobs=4 --retry=3 --clean \
    && pnpm install --frozen-lockfile --prefer-offline

# Copy the rest of the application
COPY . .

# Set environment variables
ENV NODE_ENV=production \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    MALLOC_ARENA_MAX=2

# Precompile assets
RUN SECRET_KEY_BASE=dummy bundle exec rake assets:precompile || true

EXPOSE 3000

# Start the application
CMD rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb

# Stage 1: Build Ruby application
FROM ruby:3.1.4-slim

# Install essential packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libvips \
    postgresql-client \
    libmagickwand-dev \
    imagemagick \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
    git \
    python3 \
    python-is-python3 \
    make \
    g++ \
    curl \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g pnpm@10.2.0

# Set working directory
WORKDIR /app

# Create necessary directories
RUN mkdir -p tmp/pids tmp/cache

# Initialize git repository (needed for husky)
RUN git init

# Copy package files first for better caching
COPY package.json ./

# Install Node.js dependencies
RUN pnpm install --no-frozen-lockfile

# Copy Ruby dependency files
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem update --system && \
    gem install bundler:2.4.22 && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle config set build.nokogiri --use-system-libraries && \
    bundle install --jobs=4 --retry=3

# Copy the rest of the application
COPY . .

# Set environment variables for the build
ENV NODE_ENV=production \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    MALLOC_ARENA_MAX=2 \
    DATABASE_URL=postgres://postgres:postgres@db:5432/unichat_production

# Build assets in steps
RUN echo "Building SDK..." && \
    pnpm run build:sdk

# Set a temporary secret key for asset precompilation
RUN export SECRET_KEY_BASE=$(head -c 32 /dev/urandom | base64) && \
    echo "Precompiling assets..." && \
    bundle exec rake assets:precompile --trace && \
    echo "Building Vite..." && \
    bundle exec rake vite:build --trace && \
    unset SECRET_KEY_BASE

# Add initialization scripts
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Add database initialization script
COPY init-db.sql /docker-entrypoint-initdb.d/
RUN chmod 755 /docker-entrypoint-initdb.d/init-db.sql

# Create entrypoint script
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Start command
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

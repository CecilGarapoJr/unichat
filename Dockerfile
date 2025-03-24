FROM ruby:3.1-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    nodejs \
    npm \
    libpq-dev \
    && npm install -g n \
    && n 20 \
    && npm install -g pnpm@9.6.1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN bundle install && \
    pnpm install

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

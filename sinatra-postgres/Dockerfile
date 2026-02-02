FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfile first for caching
COPY Gemfile ./
RUN bundle install

# Copy application code
COPY . .

EXPOSE 4567

CMD ["ruby", "app.rb"]

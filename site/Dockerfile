# Use the official Ruby 3 base image
FROM ruby:3.2

# Set up environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    curl \
    gnupg2

# Install the latest version of Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Install the latest version of Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends yarn

# Create and set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock ./

# Install the RubyGems dependencies
RUN bundle config --global frozen 1
RUN bundle install --jobs 20 --retry 5

# Copy the Rails application code to the working directory
COPY . .

# Precompile the assets
RUN RAILS_ENV=development bundle exec rails assets:precompile

# Expose port 3000 for the Rails application
EXPOSE 3000

# Start the Rails server
CMD RAILS_ENV=development bundle exec rails server -b 0.0.0.0

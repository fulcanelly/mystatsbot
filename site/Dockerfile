FROM ruby:3.2-alpine

# Set up environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Install system dependencies
RUN apk update && \
    apk add --no-cache build-base nodejs postgresql-dev tzdata

# Create and set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the working directory
COPY Gemfile ./

# Install the RubyGems dependencies
RUN gem install bundler && \
    bundle install --jobs 20 --retry 5

# Copy the Rails application code to the working directory
COPY . .

# Precompile the assets
RUN bundle exec rake assets:precompile

# Expose port 3000 for the Rails application
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

FROM ruby:3.2.2

# Define build-time variables
ARG SECRET_KEY_BASE

# Update package lists and install necessary tools
RUN apt-get update && \
    apt-get install -y curl gnupg build-essential imagemagick libmagickwand-dev libpq-dev poppler-utils libvips libvips-dev

# Install Node.js and npm using Nodesource setup
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install global npm packages
RUN npm install -g yarn less

# Clean up unnecessary files
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/* /var/cache /var/log /var/lib/{apt,dpkg}

# Set environment variables
ENV APP_HOME=/ideo \
    RAILS_ENV=production \
    SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Create the application directory
RUN mkdir $APP_HOME

# Set the working directory
WORKDIR $APP_HOME

# Add the Gemfile and Gemfile.lock
ADD Gemfile Gemfile.lock $APP_HOME/

# Install gems
RUN bundle install --jobs 8 --without development test

# Add the rest of the application files
ADD . $APP_HOME/

# Precompile assets
RUN bin/rake assets:precompile && \
    bin/rake assets:clean

# Command to start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


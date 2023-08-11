# Base image
ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

# Sets an environment variable with the bundle directory
ENV BUNDLE_PATH=/bundle

# Sets an argument variable with the application directory
ARG APP_HOME=/app

# Run security updates
RUN apt-get update && apt-get upgrade -y

# Install curl
RUN apt-get install -y curl

# Install PostgreSQL client and Geo libraries
RUN apt-get install -y postgresql-client libpq-dev

# The following are used to trim down the size of the image by removing unneeded data
RUN apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

# Install Bundler
ARG BUNDLER_VERSION
RUN gem install bundler -v $BUNDLER_VERSION --no-doc

# Update the system
RUN apt-get update -y

# Install Chromium for the feature tests
RUN apt-get install -y --no-install-recommends chromium

## Install gems in a separate Docker fs layer
WORKDIR /gems
COPY Gemfile Gemfile.lock ./
RUN bundle

## Node
ARG NODE_MAJOR
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -
RUN apt-get install -y nodejs

## Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

## Install yarn dependencies in a separate Docker fs layer
WORKDIR /js
COPY package.json yarn.lock ./
RUN yarn install

WORKDIR /app

RUN groupadd -r app && \
    useradd --no-log-init -r -g app -d /app app
USER app:app

COPY . .

# Sets an interactive shell as default command when the container starts
CMD ["/bin/sh"]

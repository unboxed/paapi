# Base image
FROM ruby:3.1.2

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
RUN gem install bundler -v 2.3.19 --no-doc

# Create a directory for our application
# and set it as the working directory
WORKDIR $APP_HOME

# Sets an interactive shell as default command when the container starts
CMD ["/bin/sh"]

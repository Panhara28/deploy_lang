FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT
# Set working directory
WORKDIR $RAILS_ROOT
# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler:2.0.2
RUN bundle install --jobs 20 --retry 5 --without development test
# Adding project files
COPY . .
EXPOSE 80
CMD ["rackup","config.ru", "--host", "0.0.0.0", "--port", "80"]
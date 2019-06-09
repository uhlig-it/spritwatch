FROM ruby:alpine

RUN apk add --no-cache build-base postgresql-dev
WORKDIR /app
ADD . /app
RUN gem install bundler
RUN bundle config --global silence_root_warning 1
RUN bundle install --jobs 4 --without=development test
CMD ["puma", "-e", "production"]

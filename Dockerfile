FROM ruby:alpine

ADD . /openwhisk_action

ENV RACK_ENV production
RUN cd /openwhisk_action && bundle install --deployment

EXPOSE 8080
CMD ["sh", "-lc", "cd /openwhisk_action && bundle exec ruby server.rb -p 8080"]

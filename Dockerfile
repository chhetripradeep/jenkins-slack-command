FROM ruby:2.3.1-alpine

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

ADD . /app

RUN chown -R nobody:nogroup /app

USER nobody

ENV RACK_ENV production
ENV VIRTUAL_PORT 8080

EXPOSE 8080
WORKDIR /app
CMD bundle exec ruby web.rb -p $VIRTUAL_PORT


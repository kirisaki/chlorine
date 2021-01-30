FROM ruby:3.0.0-alpine
RUN mkdir /app
WORKDIR /app
RUN apk update && apk upgrade &&apk add alpine-sdk sqlite-dev tzdata 
ADD Gemfile /app/Gemfile
ADD . /app
RUN bundle install
RUN apk del alpine-sdk
CMD ["bundle","exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]

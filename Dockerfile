FROM ruby:3.0.0-alpine

RUN mkdir /app

WORKDIR /app

RUN apk update && apk upgrade &&apk add alpine-sdk mysql-dev mysql-client tzdata 

ADD Gemfile /app/Gemfile

ADD . /app

RUN gem update bundler

RUN bundle install

RUN apk del alpine-sdk

RUN mkdir /image

CMD ["bundle","exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]

FROM ruby:2.7.3

ENV APP_HOME /app

RUN apt-get update -qq \
  && apt-get install -y nodejs postgresql-client --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler -v '2.1.4' -N

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

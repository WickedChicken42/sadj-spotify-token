FROM ruby:2.6.2

WORKDIR /app

RUN useradd swap-service --create-home && \
  chown -R swap-service:swap-service /app

USER swap-service

RUN gem install bundler:2.1.4

RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["rackup", "--host", "0.0.0.0"]

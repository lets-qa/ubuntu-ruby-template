FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    libpq-dev \
    postgresql-client \
    software-properties-common \
    tmux\
    libssl-dev \
    zlib1g-dev \
    libreadline-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    libffi-dev

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable

RUN  /bin/bash -l -c "rvm install ruby-3.2.2 --with-openssl-dir=$HOME/.rvm/usr"

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN /bin/bash -l -c "rvm use ruby-3.2.2 && gem install bundler && bundle install"

COPY . /app

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
FROM ruby:2-alpine

ARG ssh_key

RUN apk add --no-cache \
    build-base \
    cmake \
    icu-dev \
    openssl-dev \
    openssh \
    git \
    && apk upgrade --no-cache \
    && mkdir -p $HOME/.ssh \
    && chmod 0700 $HOME/.ssh \
    && echo "${ssh_key}" > $HOME/.ssh/id_rsa \
    && chmod 0600 $HOME/.ssh/id_rsa \
    && ssh-keyscan -t rsa github.com > $HOME/.ssh/known_hosts

RUN gem install github-linguist \
    && gem install gollum \
    && gem install org-ruby

COPY entrypoint.sh /
COPY daily-sync.sh /etc/periodic/daily

ENTRYPOINT ["sh", "entrypoint.sh"]
EXPOSE 4567
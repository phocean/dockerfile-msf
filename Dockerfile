FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# PosgreSQL DB
COPY ./scripts/db.sql /tmp/

# Startup script
COPY ./scripts/init.sh /usr/local/bin/init.sh

# conf
COPY ./contrib/tmux.conf /root/.tmux.conf
COPY ./contrib/vimrc /root/.vimrc

# Installation
RUN apt-get -qq update \
  && apt-get -yq install --no-install-recommends build-essential patch ruby-bundler ruby-dev zlib1g-dev liblzma-dev git autoconf build-essential libpcap-dev libpq-dev libsqlite3-dev \
    postgresql postgresql-contrib postgresql-client dialog apt-utils \
    ruby nmap nasm tmux vim \
  && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && git clone https://github.com/rapid7/metasploit-framework.git \
  && cd metasploit-framework \
  && git fetch --tags \
  && lockedTag="6.3.20" \
  && git checkout $lockedTag \
  && rm Gemfile.lock \
  && bundle install \
  && /etc/init.d/postgresql start && chmod 666 /tmp/db.sql && su - postgres -c "psql -f /tmp/db.sql" \
  && apt-get -y remove --purge build-essential patch ruby-dev zlib1g-dev liblzma-dev git autoconf build-essential libpcap-dev libpq-dev libsqlite3-dev dialog apt-utils \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

# DB config
COPY ./conf/database.yml /opt/metasploit-framework/config/

# Configuration and sharing folders
VOLUME /root/.msf4/
VOLUME /tmp/data/

# Locales for tmux
ENV LANG C.UTF-8
WORKDIR /opt/metasploit-framework

CMD "init.sh"

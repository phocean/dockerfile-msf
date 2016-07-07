FROM debian:jessie

MAINTAINER Phocean <jc@phocean.net>

WORKDIR /opt

# Base packages
RUN apt-get update && apt-get -y install \
  git build-essential zlib1g zlib1g-dev \
  libxml2 libxml2-dev libxslt-dev locate \
  libreadline6-dev libcurl4-openssl-dev git-core \
  libssl-dev libyaml-dev openssl autoconf libtool \
  ncurses-dev bison curl wget xsel postgresql \
  postgresql-contrib postgresql-client libpq-dev \
  libapr1 libaprutil1 libsvn1 \
  libpcap-dev libsqlite3-dev libgmp3-dev \
  nasm tmux vim nmap \
  && rm -rf /var/lib/apt/lists/*

# Get Metasploit
WORKDIR /opt
RUN git clone https://github.com/rapid7/metasploit-framework.git msf
WORKDIR msf

# RVM
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import
RUN curl -L https://get.rvm.io | bash -s stable 
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.3.1"
RUN /bin/bash -l -c "rvm use 2.3.1 --default"
RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && which bundle"
RUN /bin/bash -l -c "which bundle"

# Get dependencies
RUN /bin/bash -l -c "BUNDLEJOBS=$(expr $(cat /proc/cpuinfo | grep vendor_id | wc -l) - 1)"
RUN /bin/bash -l -c "bundle config --global jobs $BUNDLEJOBS"
RUN /bin/bash -l -c "bundle install"

# Symlink tools to $PATH
RUN for i in `ls /opt/msf/tools/*/*`; do ln -s $i /usr/local/bin/; done
RUN ln -s /opt/msf/msf* /usr/local/bin

# Install PosgreSQL
ADD ./scripts/db.sql /tmp/
RUN /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql"
USER root
ADD ./conf/database.yml /opt/msf/config/

# tmux configuration file
ADD ./conf/tmux.conf /root/.tmux.conf
# startup script
ADD ./scripts/init.sh /usr/local/bin/init.sh

# settings and custom scripts folder
VOLUME /root/.msf4/
VOLUME /tmp/data/

# Starting script (DB + updates)
CMD /usr/local/bin/init.sh

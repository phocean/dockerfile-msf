FROM debian:stable

MAINTAINER Phocean <jc@phocean.net>

# Base packages
RUN apt-get update && apt-get -y install \
  curl wget postgresql \
  postgresql-contrib postgresql-client \
  nasm tmux vim nmap gnupg apt-transport-https \
  tor socat proxychains \
  && curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - \
  && echo "deb https://apt.metasploit.com/ jessie main" >> /etc/apt/sources.list \
  && apt-get update -qq \
  && apt-get install metasploit-framework \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/metasploit-framework

# Install PosgreSQL
ADD ./scripts/db.sql /tmp/
RUN /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql"
USER root
ADD ./conf/database.yml /usr/share/metasploit-framework/config/

# tmux configuration file
ADD ./conf/tmux.conf /root/.tmux.conf
# startup script
ADD ./scripts/init.sh /usr/local/bin/init.sh

# settings and custom scripts folder
VOLUME /root/.msf4/
VOLUME /tmp/data/

# locales for tmux
ENV LANG C.UTF-8

# Starting script (DB + updates)
CMD /usr/local/bin/init.sh

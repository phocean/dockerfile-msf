FROM debian:stable

MAINTAINER Phocean <jc@phocean.net>

# Base packages
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-suggests --no-install-recommends \
    apt-transport-https bind9-host bzip2 ca-certificates cron curl dh-python dirmngr distro-info-data dnsutils exim4 exim4-base exim4-config exim4-daemon-light file geoip-database gnupg gnupg-agent gnupg-l10n \
    guile-2.0-libs krb5-locales libassuan0 libbind9-140 libblas-common libblas3 libbsd0 libc-l10n libcap2 libcurl3 libcurl3-gnutls libdns162 libedit2 libevent-2.0-5 libexpat1 libffi6 libfribidi0 libgc1c2 \
    libgeoip1 libgfortran3 libgmp10 libgnutls30 libgpm2 libgsasl7 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libisc160 libisccc140 libisccfg140 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 \
    libksba8 libkyotocabinet16v5 libldap-2.4-2 libldap-common liblinear3 libltdl7 liblua5.3-0 liblwres141 liblzo2-2 libmagic-mgc libmagic1 libmailutils5 libmariadbclient18 libmpdec2 libncurses5 libnettle6 \
    libnghttp2-14 libnpth0 libntlm0 libp11-kit0 libpcap0.8 libpopt0 libpq5 libprocps6 libproxychains3 libpsl5 libpython-stdlib libpython2.7 libpython2.7-minimal libpython2.7-stdlib libpython3-stdlib \
    libpython3.5-minimal libpython3.5-stdlib libquadmath0 libreadline7 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libseccomp2 libsensors4 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 \
    libunistring0 libutempter0 libwrap0 libxml2 libxslt1.1 locales logrotate lsb-release mailutils mailutils-common mime-support mysql-common nasm ndiff nmap openssl pinentry-curses postgresql postgresql-9.6 \
    postgresql-client postgresql-client-9.6 postgresql-client-common postgresql-common postgresql-contrib postgresql-contrib-9.6 procps proxychains psmisc publicsuffix python python-bs4 python-chardet \
    python-html5lib python-lxml python-minimal python-pkg-resources python-six python-webencodings python2.7 python2.7-minimal python3 python3-minimal python3.5 python3.5-minimal readline-common sgml-base socat \
    ssl-cert sysstat tcpd tmux tor tor-geoipdb torsocks ucf vim vim-common vim-runtime wget xml-core xxd xz-utils \
  && curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - \
  && echo "deb https://apt.metasploit.com/ jessie main" >> /etc/apt/sources.list \
  && apt-get update -qq \
  && apt-get install -y metasploit-framework \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/metasploit-framework

# Prepare PosgreSQL
COPY ./scripts/db.sql /tmp/
RUN /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql"
USER root
COPY ./conf/database.yml /usr/share/metasploit-framework/config/

# tmux configuration file
COPY ./conf/tmux.conf /root/.tmux.conf
# startup script
COPY ./scripts/init.sh /usr/local/bin/init.sh

# settings and custom scripts folder
VOLUME /root/.msf4/
VOLUME /tmp/data/

# locales for tmux
ENV LANG C.UTF-8

# Starting script (DB + updates)
CMD "init.sh"
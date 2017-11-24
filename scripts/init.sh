#!/bin/bash
set -e

rm -f /var/run/postgresql/*.pid

/etc/init.d/postgresql start
#/opt/metasploit-framework/bin/msfupdate
/bin/bash
#!/bin/bash

source /usr/local/rvm/scripts/rvm
/etc/init.d/postgresql start
/opt/msf/msfupdate
/opt/msf/msfconsole

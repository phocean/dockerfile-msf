# Debian-base Metasploit Framework dockerfil

# Purpose

This Dockerfile builds a Debian-based Docker container with Metasploit-Framework installed.

MSF is started automatically with:

- all dependancies installed,
- automatic updates at startup,
- a connection with the local Postgres database,
- an improved prompt with timestamping and sessions/jobs status.

# Instructions

To build the container, just use this command:

```
docker run -d -p 80:9001 -t debian-etherpad
```

Docker will download the Debian image and then execute the installation steps.

# Run

Once the build process is over, get and enjoy a neat msf prompt with this command:

```
docker run -i -t -p 9990-9999:9990-9999 debian-msf
```

# Access to the shell

If for some reason, you need to access to the shell, type this command from within the msf instance :

```
/bin/bash
```

You may also launch bash from Docker:

```
docker exec -i -t debian-msf /bin/bash
```

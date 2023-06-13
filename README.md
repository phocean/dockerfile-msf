# Metasploit Framework dockerfile

# Use by Simspace

This repository provides a version locked Docker image with the Metasploit-Framework installed.

The purpose is to provide a stable version locked Metasploit image that can be easily updated.

# Why version lock

**Reproducibility: A specific version will always represent the same state. If you use latest, you might get different results at different points in time as the latest tag updates. This could lead to unexpected behavior if the latest version includes breaking changes.

**Stability: Depending on the latest tag can introduce instability in your application if the newer versions of your base images introduce bugs, break backward compatibility, or change their behavior in unexpected ways.

**Debugging and Troubleshooting: If a problem arises in the production, it will be easier to debug if you know exactly which versions of every component were in use. With the latest tag, you might not even know which version was in use when the problem occurred.

**Security: Although using the latest version may seem like a good idea from a security perspective (as it may include patches for recent vulnerabilities), it could also introduce new vulnerabilities. It's generally better to periodically update the versions you use, after testing that the new version doesn't break your application or introduce new vulnerabilities.

# Existing Documentation

# Purpose

This Dockerfile builds a Debian-based Docker container with Metasploit-Framework installed.

**A quick and easy way to deploy Metasploit on any box, including Linux, MacOS or Windows!**

![phocean/msf](https://raw.githubusercontent.com/phocean/dockerfile-debian-metasploit/master/screenshot.png)

MSF is started automatically with:

- all dependencies installed,
- automatic updates at startup,
- a connection with the local Postgres database,
- volumes, to share data and get access to your custom Metasploit scripts.

It also includes:

- tmux, to use multiple windows (msfconsole, shell, etc.) inside the container;
- nmap, the famous network scanner (along with ncat);
- nasm, to support custom encoders;
- a configuration file to get an improved prompt in Metasploit, with timestamping and sessions/jobs status.

# Use

The image is built every day by Docker Hub, upon the Dockerfile of my github repository.

The image is based on Ubuntu LTS and the nighly builds Metasploit repository.

Also note that the image is signed (trusted content) so that the integrity of each layer in the image is checked.

You can get the image with this simple command:

```bash
docker pull phocean/msf
```

This command will download the image and you should have it available in your local image repository:

```bash
docker images
```


# Run

Now, you can enjoy a neat msf prompt with this command:

```bash
docker run --rm -i -t -p 9990-9999:9990-9999 -v $HOME/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data --name msf phocean/msf
```

From there, you can start *msfconsole*, *tmux* or any other Metasploit tool (*msfvenom*, *pattern_offset.rb*, etc.).

Explanations:

- We map the port range from 9990 to 9999 to our host, to catch reverse shells back.
- We mount the local *.msf4* folder, where you can set your prompt and put custom scripts and modules, to */root/.msf4* inside the container (if you want to make some changes at runtime, beware to do it from your host, not from within the container).
- Similarly, we mount a */tmp/data folder* to exchange data (a dump from a successful exploit, for instance).

Of course, it is up to you to adjust it to your taste or need.

You can also give it full access to the host network:

> Note that this can be **risky** as all services on your host, including those that listen on localhost, would be reachable from within the container, in case it is compromise.

```bash
docker run --rm -it --net=host --hostname msf -v $HOME/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data --name msf phocean/msf
```

When you need extra terminals besides, use an alias such as:

```bash
docker exec -it msf /bin/bash
```

At any time, you can exit, which only stops (suspend) the container.

Because of the *--rm*, the container itself is *not persistent*.

Persistency is however partially made throught the mounting of your local folders (history, scripts).
So if you want to restart a session, just re-run the docker.

I find it more convenient, but if, for some reason, you prefer to keep the container, just remove the *--rm* and then you can restart the stopped container anytime:

```bash
docker restart msf
docker attach msf
# Later:
docker rm msf
```

# Keep it up-to-date

The image is built daily from Docker Hub, so for example I use a crontab entry to keep it up-to-date:

```
*/5 * * * *     root      docker pull phocean/msf
```

Alternatively, you can keep all your images (not only phocean/msf) with such a command:

```
/usr/bin/docker images | awk '(NR>1) && ($2!~/none/) {print $1":"$2}' | xargs -L1 docker pull 2>&1 > /dev/null
```

Finally, you can choose to build it manually with the steps described below.

# Build

If for some reason, including trust, you prefer to build the container, just use this command:

```bash
docker build -t phocean/msf .
```

Alternatively, you can use the provided `start.sh` script.

Docker will download the Debian image and then execute the installation steps.

> Be patient, the process can be quite long the first time.

Note that you may want to:

- copy the *contrib/config* file to the *~/.msf4* folder to get a nice prompt.
- customize the *conf/tmux* file, if you plan to use this tool.

> The configuration of Tmux maps the keyboard as in Screen (CTRL-A). It also makes a few cosmetic changes to the status bar.

> Note that you could adjust the init script to automatically launch Tmux with a msf window and a bash one, for instance. I don't make it the default, because I don't want to bother people who don't need/want Tmux.*

# Contributors

Thanks to contributors that helped this project:

* [Lenny Zeltser](https://github.com/lennyzeltser)
* [llyus](https://github.com/pierrickv)
* [r0mdau](https://github.com/r0mdau)

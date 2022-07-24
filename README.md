# Metasploit Framework dockerfile

# Purpose

This Dockerfile builds a Debian-based Docker container with Metasploit-Framework installed.

**A quick and easy way to deploy Metasploit on any box, including Linux, MacOS or Windows!**

![img-msf](screenshot.png)

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
docker pull r0mdau/msf
```

This command will download the image and you should have it available in your local image repository:

```bash
docker images
```


# Run

Now, you can enjoy a neat msf prompt with this command:

```bash
docker run --rm -i -t -p 9990-9999:9990-9999 -v $HOME/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data --name msf r0mdau/msf
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
docker run --rm -it --net=host --hostname msf -v $HOME/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data --name msf r0mdau/msf
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
*/5 * * * *     root      docker pull r0mdau/msf
```

Alternatively, you can keep all your images (not only r0mdau/msf) with such a command:

```
/usr/bin/docker images | awk '(NR>1) && ($2!~/none/) {print $1":"$2}' | xargs -L1 docker pull 2>&1 > /dev/null
```

Finally, you can choose to build it manually with the steps described below.

# Build

If for some reason, including trust, you prefer to build the container, just use this command:

```bash
docker build -t r0mdau/msf .
```

Alternatively, you can use the provided `start.sh` script.

Docker will download the Debian image and then execute the installation steps.

> Be patient, the process can be quite long the first time.

Note that you may want to:

- copy the *contrib/config* file to the *~/.msf4* folder to get a nice prompt.
- customize the *conf/tmux* file, if you plan to use this tool.

> The configuration of Tmux maps the keyboard as in Screen (CTRL-A). It also makes a few cosmetic changes to the status bar.

> Note that you could adjust the init script to automatically launch Tmux with a msf window and a bash one, for instance. I don't make it the default, because I don't want to bother people who don't need/want Tmux.*

# Verify signature

The docker image [r0mdau/msf](https://hub.docker.com/repository/docker/r0mdau/msf) is :

* built and pushed to [docker hub](https://hub.docker.com/repository/docker/r0mdau/msf) with a github [action](.github/workflows/publish-image.yml)
* signed with [Cosign](https://github.com/sigstore/cosign) from the [Sigstore](https://www.sigstore.dev/) project

To verify the signature, simply download the [public key](cosign.pub) and run :

```
docker pull r0mdau/msf
cosign verify --key cosign.pub r0mdau/msf
```

# Contributors

Thanks to contributors that helped this project:

* [Lenny Zeltser](https://github.com/lennyzeltser)
* [llyus](https://github.com/pierrickv)
* [r0mdau](https://github.com/r0mdau)

# ekino/apt-mirror

## Description

This is the [official source]
(https://github.com/ekino/docker-images/tree/master/apt-mirror)
of the [ekino/apt-mirror]
(https://registry.hub.docker.com/u/ekino/apt-mirror/)
docker image.

Its purpose is to get a local mirror of all your required packages so you can
work efficiently without any Internet connection.
All it requires is enough disk space which doesn't cost anything anymore...

## Details

This very first version provides images to create Docker images with Ubuntu
14.04 mirror

Each image is built on top of the previous one following the *de-facto* order
`main` > `restricted` > `universe` > `multiverse`.

## Available Tags

This very first version only contains mirrors for Ubuntu 14.04 :
- `trusty-main` - [main/Dockerfile](https://github.com/ekino/docker-images/tree/master/apt-mirror/main)
- `trusty-restricted` - [restricted/Dockerfile](https://github.com/ekino/docker-images/tree/master/apt-mirror/restricted)
- `trusty-universe` - [universe/Dockerfile](https://github.com/ekino/docker-images/tree/master/apt-mirror/universe)
- `trusty-multiverse` - [multiverse/Dockerfile](https://github.com/ekino/docker-images/tree/master/apt-mirror/multiverse)

## Usage

### Use Case 1: Start a mirror container - Serve other containers

First start the mirror container.
You must give a name for this container so it can be linked later (see below).

```bash
docker run -d --name ubuntu-mirror ekino/apt-mirror:universe
```

Then start any ubuntu trusty-based client container by either:

**1- [DIRTY] overriding dns resolution**

The following command add an entry in `/etc/hosts`.
Once inside the container, you'll have to :
- first remove the lists cache to prevent update errors `rm -rf /var/lib/apt/lists`
- edit the `/etc/apt/sources.list` to fit with your local mirror available content (main, restricted, universe....)

```bash
FQDN="archive.ubuntu.com"
docker run -ti --link ubuntu-mirror:$FQDN ubuntu:14.04 /bin/bash
```

**2- [RECOMMENDED] overriding the source.list**

The following command create an ad-hoc `source.list` used along with the
container started just after.
Here, you're not tied to the configuration of the image, and don't have
additional commands at startup.

```bash
FQDN="unrelevant-fake-dns-entry.local"
cat <<EOF > sources.list-$FQDN
deb http://$FQDN/ubuntu/ trusty main restricted
deb http://$FQDN/ubuntu/ trusty-updates main restricted
deb http://$FQDN/ubuntu/ trusty-backports main restricted
deb http://$FQDN/ubuntu/ trusty-security main restricted
EOF

docker run -ti --link ubuntu-mirror:$FQDN -v $(readlink -f sources.list-$FQDN):/etc/apt/sources.list ubuntu:14.04 /bin/bash
```

Once inside your container, you can `apt-get install` without any Internet connection

### Use Case 2: Start a mirror container - Serve other hosts (VM or real hosts)

First start the mirror container.
You must publish the local exposed port to your host.

```bash
# Dynamic
docker run -P -d --name ubuntu-mirror ekino/apt-mirror:restricted
docker ps # <- to see which port it has been associated to

# Static
docker run -p 80:80 -d --name ubuntu-mirror ekino/apt-mirror:restricted
```

You then must configure your trusty-based client's source.list so he speaks with your local mirror.

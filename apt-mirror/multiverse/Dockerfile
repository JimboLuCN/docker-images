FROM ekino/apt-mirror:universe

MAINTAINER Matthieu Fronton <fronton@ekino.com>

# Some mirrors don't have the required packages for mirror
# So we keep the default one
#ADD fastestmirror.list /etc/apt/sources.list
ADD mirror.list-multiverse /etc/apt/mirror.list
ADD nginx.site-available.mirror-local /etc/nginx/sites-available/mirror.local

RUN apt-get update ;     DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::Options::=--force-confold install apt-mirror nginx ;     mkdir -p /var/www/mirror.local ;     mkdir -p /mirrors ;     apt-mirror ;     ln -s /mirrors/mirror/ubuntu-archive.mirrors.proxad.net/ubuntu /var/www/mirror.local/ubuntu ;     sed -i '/^daemon/d' /etc/nginx/nginx.conf ;     sed -i '/^worker_processes/a daemon off;' /etc/nginx/nginx.conf ;     rm /etc/nginx/sites-enabled/default ;     ln -sf /etc/nginx/sites-available/mirror.local /etc/nginx/sites-enabled/

EXPOSE 80
CMD ["service", "nginx", "start"]

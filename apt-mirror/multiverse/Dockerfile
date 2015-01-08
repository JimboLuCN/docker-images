FROM ekino/apt-mirror:trusty-universe

MAINTAINER Matthieu Fronton <fronton@ekino.com>

# Some mirrors don't have the required packages for mirror
# So we keep the default one
#ADD fastestmirror.list /etc/apt/sources.list
ADD mirror.list-trusty-multiverse /etc/apt/mirror.list
ADD nginx.site-available.mirror-local /etc/nginx/sites-available/mirror.local

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::Options::=--force-confold install apt-mirror nginx
RUN mkdir -p /var/www/mirror.local
RUN mkdir -p /mirrors
RUN apt-mirror
RUN ln -sf /mirrors/mirror/ubuntu-archive.mirrors.proxad.net/ubuntu /var/www/mirror.local/ubuntu
RUN sed -i '/^daemon/d' /etc/nginx/nginx.conf
RUN sed -i '/^worker_processes/a daemon off;' /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/default
RUN ln -sf /etc/nginx/sites-available/mirror.local /etc/nginx/sites-enabled/

EXPOSE 80

CMD ["service", "nginx", "start"]

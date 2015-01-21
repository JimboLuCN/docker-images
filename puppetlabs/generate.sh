#!/bin/sh

releases="precise trusty"

for i in $releases
do
  rm -rf "$i"
  mkdir -p "$i"
  cp fastestmirror.list "$i"
  cat <<Dockerfile > "$i/Dockerfile"
FROM ubuntu:$i

MAINTAINER Matthieu Fronton <fronton@ekino.com>

#ADD fastestmirror.list /etc/apt/sources.list

WORKDIR /root

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget lsb-release apt-utils ca-certificates
RUN wget -nv https://apt.puppetlabs.com/puppetlabs-release-\$(lsb_release -cs).deb
RUN dpkg -i puppetlabs-release-\$(lsb_release -cs).deb
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y puppet
RUN rm puppetlabs-release-\$(lsb_release -cs).deb
RUN [ \$(lsb_release -sc) = 'precise' ] && apt-get install rubygems
RUN gem install deep_merge

CMD ["/bin/bash"]
Dockerfile

done

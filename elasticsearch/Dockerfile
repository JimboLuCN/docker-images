# --- ELASTICSEARCH ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND=noninteractive
ENV ELASTICSEARCH_VERSION 1.4

# required tools
RUN apt-get update
RUN apt-get install -y wget

# install elasticsearch
RUN wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"
RUN apt-get update
RUN apt-get install -y elasticsearch openjdk-7-jre-headless supervisor

# cleanup
RUN apt-get autoremove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9200

CMD ["supervisord","-n"]
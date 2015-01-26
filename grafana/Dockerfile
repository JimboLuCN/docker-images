# --- GRAFANA ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive
ENV GRAFANA_VERSION 1.9.1

# required tools
RUN apt-get update
RUN apt-get install -y wget supervisor python-twisted

# install grafana
RUN wget http://grafanarel.s3.amazonaws.com/grafana-${GRAFANA_VERSION}.tar.gz -O grafana.tar.gz
RUN mkdir -p /opt
RUN tar xzf grafana.tar.gz -C /opt
RUN ln -sf /opt/grafana-${GRAFANA_VERSION} /opt/grafana
RUN rm grafana.tar.gz

# cleanup
RUN apt-get autoremove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/grafana.conf
ADD config.js /opt/grafana/config.js

ENV INFLUXDB_URL http://influxdb:8086
ENV ELASTICSEARCH_URL http://elasticsearch:9200
RUN sed -i 's,ELASTICSEARCH_URL,'${ELASTICSEARCH_URL}',' /opt/grafana/config.js
RUN sed -i 's,INFLUXDB_URL,'${INFLUXDB_URL}',' /opt/grafana/config.js

EXPOSE 8080

CMD ["supervisord","-n"]

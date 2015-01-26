# --- INFLUXDB ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive
ENV INFLUXDB_VERSION 0.8.8

# required tools
RUN apt-get update
RUN apt-get install -y curl supervisor

# install influxdb
RUN curl -s -o influxdb.deb https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb
RUN dpkg -i influxdb.deb
RUN rm influxdb.deb

# cleanup
RUN apt-get autoremove -y curl
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/influxdb.conf

EXPOSE 8083
EXPOSE 8086
EXPOSE 8084
EXPOSE 8090
EXPOSE 8099

VOLUME ["/data"]

CMD ["supervisord","-n"]
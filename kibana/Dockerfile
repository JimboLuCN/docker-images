# --- KIBANA ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND=noninteractive
ENV KIBANA_VERSION 3.1.0

# required tools
RUN apt-get update
RUN apt-get install -y python-twisted wget

# install kibana
# TODO: try installing w/o wget using ADD directly on http path
RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz -O kibana.tar.gz
RUN mkdir -p /opt
RUN tar xzf kibana.tar.gz -C /opt
RUN ln -sf /opt/kibana-${KIBANA_VERSION} /opt/kibana
RUN rm -f kibana.tar.gz

# cleanup
RUN apt-get autoremove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cp /opt/kibana/app/dashboards/logstash.json /opt/kibana/app/dashboards/default.json

ENV ELASTICSEARCH_URL http://localhost:9200
# TODO: configure elasticsearch url using this env variable

EXPOSE 8080

CMD ["/usr/bin/twistd", "-n", "web", "--path", "/opt/kibana"]

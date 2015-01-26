# --- KIBANA ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive
ENV KIBANA_VERSION 3.1.0

# required tools
RUN apt-get update
RUN apt-get install -y wget supervisor python-twisted

# install kibana
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
ADD supervisord.conf /etc/supervisor/conf.d/kibana.conf
RUN cp /opt/kibana/app/dashboards/logstash.json /opt/kibana/app/dashboards/default.json

ENV ELASTICSEARCH_URL http://elasticsearch:9200
RUN sed -i '32d;33ielasticsearch: "'$ELASTICSEARCH_URL'",' /opt/kibana/config.js

EXPOSE 8080

CMD ["supervisord","-n"]

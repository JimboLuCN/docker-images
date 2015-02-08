# --- RABBITMQ ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive

# required tools
RUN apt-get update
RUN apt-get install -y supervisor

# install rabbitmq
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F7B8CEA6056E8E56
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y rabbitmq-server
RUN rabbitmq-plugins --offline enable rabbitmq_management
RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/rabbitmq.conf
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config
ADD start.sh /start.sh

EXPOSE  5672
EXPOSE 15672

CMD ["/start.sh"]
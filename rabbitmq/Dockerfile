# --- RABBITMQ ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive

# required tools
RUN apt-get update
RUN apt-get install -y supervisor # pwgen

# install rabbitmq
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F7B8CEA6056E8E56
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y rabbitmq-server
RUN rabbitmq-plugins enable rabbitmq_management

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/rabbitmq.conf
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config

EXPOSE  5672
EXPOSE 15672

CMD ["supervisord","-n"]
# --- TOMCAT ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_VERSION 7
ENV TOMCAT_VERSION 8.0.11

# preset
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886
RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
RUN echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
RUN apt-get update

# install java
RUN echo oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y --force-yes oracle-java${JAVA_VERSION}-installer oracle-java${JAVA_VERSION}-set-default supervisor wget # pwgen

# install tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION%%.*}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION%%.*}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.md5 | md5sum -c -
RUN mkdir -p /opt
RUN tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt
RUN rm apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# cleanup
RUN apt-get autoremove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists
RUN rm -rf /var/cache/oracle-jdk${JAVA_VERSION}-installer

# configure
# TODO: create 1st user
ADD supervisord.conf /etc/supervisor/conf.d/tomcat.conf

EXPOSE 80

CMD ["supervisord","-n"]
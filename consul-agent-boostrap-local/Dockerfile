FROM ubuntu:saucy
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install  curl zip lib32z1 lib32ncurses5 lib32bz2-1.0 

# Install consul
RUN curl -s -L -O https://dl.bintray.com/mitchellh/consul/0.1.0_linux_386.zip
RUN unzip 0.1.0_linux_386.zip
RUN cp consul /usr/bin/consul
RUN chmod 555 /usr/bin/consul

RUN mkdir -p /etc/consul.d
#ADD consul.json /etc/consul.d/consul.json
#RUN chmod 644 /etc/consul.d/consul.json

# Expose consul ports
EXPOSE 8300 8301 8302 8400 8500 8600 8300/udp 8301/udp 8302/udp 8400/udp 8500/udp 8600/udp 

# start consul
CMD /usr/bin/consul agent -server -bootstrap -data-dir=/tmp/consul -log-level debug


FROM ubuntu:saucy
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor curl zip lib32z1 lib32ncurses5 lib32bz2-1.0 iputils-ping telnet net-tools

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /run.sh

# Install consul
RUN curl -s -L -O https://dl.bintray.com/mitchellh/consul/0.2.0_linux_386.zip
RUN unzip 0.2.0_linux_386.zip
RUN cp consul /usr/bin/consul
RUN chmod 555 /usr/bin/consul

# Install consul UI
RUN curl -s -L -O https://dl.bintray.com/mitchellh/consul/0.2.0_web_ui.zip
RUN unzip -d /consul-ui 0.2.0_web_ui.zip

# Add consul to supervisord
ADD consul-supervisord.conf /etc/supervisor/conf.d/consul-supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/consul-supervisord.conf

RUN mkdir -p /etc/consul.d
#ADD consul.json /etc/consul.d/consul.json
#RUN chmod 644 /etc/consul.d/consul.json

ADD consul_start.sh /consul_start.sh
RUN chmod 755 /consul_start.sh

# Add consul_check
ADD check_consul-supervisord.conf /etc/supervisor/conf.d/check_consul-supervisord.conf
ADD check_consul.sh /check_consul.sh
RUN chmod 755 /check_consul.sh

# Expose consul ports
EXPOSE 8300 8300/udp 8301 8301/udp 8302 8302/udp 8400 8400/udp 8500 8500/udp 8600 8600/udp 

# start supervisord -- ATTENTION: consul startup requires that this container be linked to another with the name CONSUL-LOCAL
# run -i -rm -name mysql-consul -link consul-agent-local-join:CONSUL_LOCAL
CMD ["./run.sh"]


# Uchiwa for Sensu
#
# Uchiwa is a simple dashboard for the Sensu monitoring framework, built with
# Go and AngularJS.

FROM ubuntu:xenial-20160923.1
MAINTAINER Jirayut Nimsaeng <jirayut [at] opsta.io>

# 1) Install Uchiwa
# 2) Copy initial configuration
ARG APT_CACHER_NG
RUN [ -n "$APT_CACHER_NG" ] && \
      echo "Acquire::http::Proxy \"$APT_CACHER_NG\";" \
      > /etc/apt/apt.conf.d/11proxy || true; \
    apt-get update && \
    apt-get install -y wget && \
    wget -q http://repositories.sensuapp.org/apt/pubkey.gpg -O- | apt-key add - && \
    echo "deb http://repositories.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list && \
    apt-get update && \
    apt-get install -y uchiwa && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/11proxy
COPY build-files/uchiwa.json /etc/sensu/uchiwa.json

EXPOSE 3000
VOLUME ["/var/log", "/etc/sensu"]
CMD ["/opt/uchiwa/bin/uchiwa", "-c", "/etc/sensu/uchiwa.json", "-p", "/opt/uchiwa/src/public"]

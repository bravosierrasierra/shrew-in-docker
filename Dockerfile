FROM debian:jessie
MAINTAINER thegitfather <baranowski@joinpoint.org>

RUN apt-get update && apt-get install -y \
    ike \
    net-tools \
    socat \
    psmisc \
    tcpdump \
    iptables

WORKDIR /root
COPY startup.sh /root
COPY sites /root/.ike/sites

ENTRYPOINT ["/root/startup.sh"]

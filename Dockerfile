FROM ubuntu:14.04
ENV TERM xterm

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://packagecloud.io/install/repositories/scalr/scalr-server-oss/script.deb -O /opt/script.deb && \
    bash /opt/script.deb && \
    apt-get install -y scalr-server && \
    apt-get clean all && \
    rm -f /opt/script.deb && \
    scalr-server-wizard && \
    scalr-server-ctl reconfigure && \
    mv /etc/scalr-server /etc/scalr-server-template && \
    mv /opt/scalr-server /opt/scalr-server-template

EXPOSE 80

VOLUME ["/etc/scalr-server","/opt/scalr-server"]

COPY assets /assets/
RUN chmod +x /assets/wrapper.sh

CMD ["/assets/wrapper.sh"]

FROM --platform=linux/amd64 ubuntu:focal
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y --no-install-recommends libldap-2.4-2 postgresql-client libxml-perl curl awscli
COPY fds_loader /fds_loader
RUN mkdir /data
CMD /fds_loader/run-loader.sh

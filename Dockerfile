FROM debian
#FROM debian:jessie
USER root

RUN apt-get update -qq
RUN apt-get install -y build-essential net-tools \
    bison flex m4 pkg-config libncurses5-dev rsyslog libmysqlclient-dev \
    libssl-dev mysql-client libmicrohttpd-dev libcurl4-openssl-dev uuid-dev \
    libpcre3-dev libconfuse-dev libxml2-dev libhiredis-dev wget lsof \
    && rm -rf /var/lib/apt/lists/* \
    && echo "deb http://packages.irontec.com/debian jessie main" >> /etc/apt/sources.list \
    && wget http://packages.irontec.com/public.key -q -O - | apt-key add - \
    && apt-get update -qq \
    && apt-get install sngrep -y

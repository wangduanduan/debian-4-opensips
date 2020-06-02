FROM debian:jessie
USER root

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai
ADD opensips-2.4.7.tar.gz /usr/local/src

RUN apt-get update -qq && apt-get install -y build-essential net-tools \
    bison flex m4 pkg-config libncurses5-dev rsyslog libmysqlclient-dev \
    libssl-dev mysql-client libmicrohttpd-dev libcurl4-openssl-dev uuid-dev \
    libpcre3-dev libconfuse-dev libxml2-dev libhiredis-dev wget lsof \
    && rm -rf /var/lib/apt/lists/* \
    && echo "deb http://packages.irontec.com/debian jessie main" >> /etc/apt/sources.list \
    && wget http://packages.irontec.com/public.key -q -O - | apt-key add - \
    && apt-get update -qq \
    && apt-get install sngrep -y

WORKDIR /usr/local/src

RUN cd /usr/local/src/opensips-2.4.7 \
    && make all -j4 include_modules="db_mysql httpd db_http siprec regex rest_client carrierroute dialplan b2b_logic cachedb_redis proto_tls proto_wss tls_mgm" \
    && make install include_modules="db_mysql httpd db_http siprec regex rest_client carrierroute dialplan b2b_logic cachedb_redis proto_tls proto_wss tls_mgm" \
    && touch /var/log/opensips.log \
    && rm -rf /usr/local/src/opensips-2.4.7/*

COPY run.sh /run.sh
COPY rsyslog.conf /etc/rsyslog.conf
COPY opensips /etc/logrotate.d/

RUN chmod +x /run.sh \
    && echo "*/10 * * * * /usr/sbin/logrotate /etc/logrotate.d/opensips" > /var/spool/cron/crontabs/root \
    && chmod 600 /var/spool/cron/crontabs/root

ENTRYPOINT ["/run.sh"]
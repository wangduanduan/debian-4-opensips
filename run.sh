#!/bin/bash
rm -rf /var/run/rsyslogd.pid
touch /var/log/opensips.log

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
service rsyslog restart
service cron start


download_cfg(){
  curl -X POST -s \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	--data "CF_INNER_IP=${CF_INNER_IP}&\
	CF_PUBLIC_IP=${CF_PUBLIC_IP}&\
	CF_IS_PROXY=${CF_IS_PROXY}&\
	CF_DB=$(mysql)&\
	CF_HOMER=$(homer)&\
	CF_LOG_LEVEL=$(log_level)&\
	CF_MPATH=$(mpath)" \
	$(sip_conf)/edge \
	-o /usr/local/etc/opensips/opensips.cfg
}

echo "RUN_PARAM is $RUN_PARAM"

if [[ -z $CF_OS_CONF ]]; then
  download_cfg()
fi

opensips $RUN_PARAM
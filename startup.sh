#!/usr/bin/env bash

echo $@

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0

BASENAME=`basename "$0"`

IKED_PID=$(pgrep iked)

if [ -z "${IKED_PID}" ]; then
	iked &
fi

function finish {
  echo "Detected SIGTERM, shuting down..."
	killall -9 ikec &>/dev/null
	exit 0
}
trap finish TERM INT


while true
do
	TUNNEL=$(ifconfig | grep "tap0")
	if [ -n "$TUNNEL" ]; then
		echo "$(date +"%T") - $BASENAME: tap0 is up"
		sleep 20
	else
		echo "$(date +"%T") - $BASENAME: tap0 is down. reconnecting.."
		killall -9 ikec &>/dev/null
		ikec -r "${VPN_KEY_FILE}" -u ${VPN_LOGIN} -p ${VPN_PASS} -a &
		sleep 10
	fi
done

exit 0

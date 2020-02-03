#!/bin/bash

if [ -z "${EXPRESSVPN_ROOT_PATH}" ]
then
  EXPRESSVPN_ROOT="/storage/expressvpn"
fi

if [ -z "${EXPRESSVPN_CONFIG_FILE}" ]
then
  EXPRESSVPN_CONFIG_PATH="${EXPRESSVPN_ROOT}/etc/expressvpn/express.ovpn"
fi

START_VPN=1

OPENVPN_PID=$(ps -ef | awk '$0 ~ /[o]penvpn/ {print $1}')

if [ ! -z "${OPENVPN_PID}" ]
then
  # VPN is running, check if it's working
  curl -sSL -o /dev/null --connect-timeout 3 https://ipv4.wtfismyip.com/text
  CURL_RETURN=$?
  if [ ${CURL_RETURN} -ne 0 ]
  then
    echo "Killing dead ExpressVPN process"
    kill -9 ${OPENVPN_PID}
  else
    echo "ExpressVPN already running"
    START_VPN=0
  fi
fi

if [ $START_VPN -eq 1 ]
then
  echo "Starting ExpressVPN"
  ${EXPRESSVPN_ROOT}/usr/sbin/openvpn-expressvpn --config ${EXPRESSVPN_CONFIG_PATH}/express.ovpn&
  disown
fi

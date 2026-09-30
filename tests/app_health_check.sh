#!/bin/bash
set -e

HOST=$1
USER=$2
PASS=$3

if [[ -z $1 ]]; then
    echo -e "Usage: app_health_check.sh [HOST] [USER] [PASS]\n"
    echo -e "Examples:\n"
    echo "-- without user authentication"
    echo -e "   app_health_check.sh 10.0.0.1\n"
    echo "-- with user authentication"
    echo "   app_health_check.sh 10.0.0.1 'user' 'pass'"
    exit 1
fi

if [[ ! $(curl -s http://${HOST}/doku.php?id=wiki:welcome -u "${USER}:${PASS}" | grep "your wiki is now up and running") ]]; then
    echo "[ERROR] HTTP health check failed on http://${HOST}/doku.php?id=wiki:welcome."
    exit 1
fi
echo "[SUCCESS] HTTP endpoint validated successfully."

#!/bin/sh

DEVPI_DIR="/var/lib/devpi"
SERVER_DIR="${DEVPI_DIR}/server"
PASSWD_FILE="${SERVER_DIR}/PASSWD"
if [ ! -d ${SERVER_DIR} ]; then
    PASSWD=`head /dev/urandom | base64 | head -c 16`
    echo "Init with password: ${PASSWD}"
    /usr/local/bin/devpi-init --serverdir ${SERVER_DIR} --no-root-pypi --root-passwd ${PASSWD}
    echo ${PASSWD} > ${PASSWD_FILE}
    chmod 600 ${PASSWD_FILE}

    /usr/local/bin/devpi-gen-config --serverdir ${SERVER_DIR} --hard-links --host 0.0.0.0
    cp gen-config/supervisor* ${DEVPI_DIR}
    supervisord --configuration "${DEVPI_DIR}/supervisord.conf"
    sleep 10

    /usr/local/bin/devpi use http://0.0.0.0:3141
    /usr/local/bin/devpi login --password ${PASSWD} root
    /usr/local/bin/devpi index -c pypi type=mirror volatile=False mirror_url=http://mirrors.aliyun.com/pypi/simple/ title=PyPI mirror_web_url_fmt=https://pypi.org/project/{name}/
else
    supervisord --configuration "${DEVPI_DIR}/supervisord.conf"
fi

tail -f supervisord.log

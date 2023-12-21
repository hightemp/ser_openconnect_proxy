#!/bin/sh

/usr/bin/tinyproxy -c /etc/tinyproxy.conf

run () {
    echo "OPENCONNECT_URL=$OPENCONNECT_URL"
    echo "OPENCONNECT_USER=$OPENCONNECT_USER"
    echo "OPENCONNECT_PASSWORD=$OPENCONNECT_PASSWORD"
    echo "OPENCONNECT_USERGROUP=$OPENCONNECT_USERGROUP"
    echo "OPENCONNECT_OPTIONS=$OPENCONNECT_OPTIONS"
    # Start openconnect
    if [[ -z "${OPENCONNECT_PASSWORD}" ]]; then
        echo "[!] Ask for password"
        openconnect -u "$OPENCONNECT_USER" --authgroup="$OPENCONNECT_USERGROUP" $OPENCONNECT_OPTIONS $OPENCONNECT_URL
    elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]] && [[ ! -z "${OPENCONNECT_MFA_CODE}" ]]; then
        echo "[!] Multi factor authentication (MFA)"
        (echo $OPENCONNECT_PASSWORD; echo $OPENCONNECT_MFA_CODE) | openconnect -u "$OPENCONNECT_USER" --authgroup="$OPENCONNECT_USERGROUP" $OPENCONNECT_OPTIONS --passwd-on-stdin $OPENCONNECT_URL
    elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]]; then
        echo "[!] Standard authentication"
        echo $OPENCONNECT_PASSWORD | openconnect --verbose -u "$OPENCONNECT_USER" --authgroup="$OPENCONNECT_USERGROUP" $OPENCONNECT_OPTIONS --passwd-on-stdin $OPENCONNECT_URL
    fi
}

until (run); do
    echo "openconnect exited. Restarting process in 60 seconds…" >&2
    sleep 60
done
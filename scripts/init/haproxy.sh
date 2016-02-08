#!/bin/sh
exec 1> /proc/1/fd/1
exec 2> /proc/1/fd/2

# Wait until /etc/haproxy/haproxy.cfg is generated
while [ ! -f /etc/haproxy/haproxy.cfg ]; do
    echo "Waiting for /etc/haproxy/haproxy.cfg..."
    sleep 1
done

exec haproxy -f /etc/haproxy/haproxy.cfg


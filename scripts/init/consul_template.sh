#!/bin/sh
exec 1> /proc/1/fd/1
exec 2> /proc/1/fd/2
echo $CONSUL_URI $CONSUL_TPL

SSL="";
if  $CONSUL_SSL; then
	SSL="-ssl"
fi

exec consul-template -consul $CONSUL_URI $SSL -template "$CONSUL_TPL:/etc/haproxy/haproxy.cfg:haproxy_reload" 

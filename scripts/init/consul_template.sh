#!/bin/sh
exec 1> /proc/1/fd/1
exec 2> /proc/1/fd/2
exec consul-template -consul $CONSUL_HOST  -template "/etc/haproxy/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:haproxy_reload" 

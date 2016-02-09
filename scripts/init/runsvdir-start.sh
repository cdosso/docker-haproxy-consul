#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin

#init QDISC 

i=0
for m in sch_plug sch_prio
do
  if ! $(lsmod | grep $m > /dev/null 2>&1); then
    echo  "WARNING: Unable to find $m kernel module"
	i=$((i+1))
  fi
done

if [ $i -eq 0 ]; then 

    # http://engineeringblog.yelp.com/2015/04/true-zero-downtime-haproxy-reloads.html

    # Set up the queuing discipline
    tc qdisc add dev lo root handle 1: prio bands 4
    tc qdisc add dev lo parent 1:1 handle 10: pfifo limit 1000
    tc qdisc add dev lo parent 1:2 handle 20: pfifo limit 1000
    tc qdisc add dev lo parent 1:3 handle 30: pfifo limit 1000

    # Create a plug qdisc with 1 meg of buffer
    nl-qdisc-add --dev=lo --parent=1:4 --id=40: plug --limit 1048576
    # Release the plug
    nl-qdisc-add --dev=lo --parent=1:4 --id=40: --update plug --release-indefinite

    # Set up the filter, any packet marked with "1" will be
    # directed to the plug
    tc filter add dev lo protocol ip parent 1:0 prio 1 handle 1 fw classid 1:4

    # Mark SYN Packets
    iptables -t mangle -I OUTPUT -p tcp -s 0.0.0.0 --syn -j MARK --set-mark 1

    echo "Queueing discipline loaded"
else
    echo "Unable to load queueing discipline"
fi

sysctl -w net.ipv4.conf.eth0.route_localnet=1

exec runsvdir -P /etc/service

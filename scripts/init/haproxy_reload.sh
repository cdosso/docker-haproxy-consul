#!/bin/bash
exec 1> /proc/1/fd/1
exec 2> /proc/1/fd/2

exec nl-qdisc-add --dev=lo --parent=1:4 --id=40: --update plug --buffer
exec sv restart haproxy
exec nl-qdisc-add --dev=lo --parent=1:4 --id=40: --update plug --release-indefinite

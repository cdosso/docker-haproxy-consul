haproxy-consul-template
===


consul-template driven haproxy with runit orchestration and zero downtime reloading


Usage
===


	docker run --cap-add NET_ADMIN --restart=always --name haproxy --link consul:consul -v $(pwd)/haproxy.ctmpl:/etc/haproxy/haproxy.ctmpl:ro -p 80:80 -p 443:443  subitolabs/haproxy-consul-template --consul consul:8500
	
Zero downtime reloading
===

For zero downtime haproxy reloading, make sure sch_plug and sch_prio kernel's features are loaded on docker host (with lsmod command) . Check for container logs.

Testing setup
===

Create a local docker-machine with our boot2docker iso.

	docker-machine create -d virtualbox  --virtualbox-boot2docker-url https://github.com/subitolabs/boot2docker/releases/download/v1.10.0-qdisc/boot2docker.iso test-qdisc
	
Enable sch_plug and sch_prio

	docker-machine ssh test-qdisc sudo modprobe sch_plug sch_prio

Then run a simple consul stack with a custom haproxy template

	docker run --restart=always -d -p 8500:8500 --name consul -e "SERVICE_IGNORE=true" progrium/consul -server -bootstrap-expect 1
	
	docker run --restart=always --name registrator --link "consul:consul"  -v /var/run/docker.sock:/tmp/docker.sock -d -e "SERVICE_IGNORE=true"  gliderlabs/registrator -internal  consul://consul:8500
	
	docker run --cap-add NET_ADMIN --restart=always --name haproxy --link consul:consul -v $(pwd)/haproxy.ctmpl:/etc/haproxy/haproxy.ctmpl:ro -p 80:80 subitolabs/haproxy-consul-template --consul consul:8500
	
	
	

	
	
	

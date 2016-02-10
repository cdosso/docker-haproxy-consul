#docker haproxy-consul-template


consul-template driven haproxy with runit orchestration ans zero downtime reloading


##Usage


	docker run --cap-add NET_ADMIN --restart=always --name haproxy --link consul:consul -v $(pwd)/haproxy.ctmpl:/etc/haproxy/haproxy.ctmpl:ro -p 80:80 -p 443:443 haproxy-consul --consul consul:8500
	
##Zero downtime reloading

For zero downtime haproxy reloading, make sure sch_plug and sch_prio kernel's features are loaded on docker host. Check for container logs.

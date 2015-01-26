# ekino/neo4j-cluster

## Description

Get a Neo4J cluster in no time.

## Init Cluster

Cluster nodes needs to talk to each other. So either we use etcd (or
similar project) or we use dnsmasq. This README only talks about this simple
poor's man approach using dnsmasq.

```bash
# Build dns server image (so nodes can communicate to each others)
docker build -t=ekino/dnsmasq:latest dns/

# Build neo4j-cluster node image
docker build -t=ekino/neo4j-cluster:latest node/

# Start dns server
docker run --name neodns -h neodns -v $(readlink -f dns/dnsmasq.d):/etc/dnsmasq.d -d ekino/dnsmasq:latest
localdns=$(docker inspect --format {{.NetworkSettings.IPAddress}} neodns)

# Start neo4j-cluster nodes
docker run --name neo1 -h neo1 --dns $localdns -e SERVER_ID=1 -P -d ekino/neo4j-cluster:latest
docker run --name neo2 -h neo2 --dns $localdns -e SERVER_ID=2 -P -d ekino/neo4j-cluster:latest
docker run --name neo3 -h neo3 --dns $localdns -e SERVER_ID=3 -P -d ekino/neo4j-cluster:latest

# Register nodes to dns server
echo "host-record=neo1,$(docker inspect --format {{.NetworkSettings.IPAddress}} neo1)" | tee dns/dnsmasq.d/50_docker_neo1
echo "host-record=neo2,$(docker inspect --format {{.NetworkSettings.IPAddress}} neo2)" | tee dns/dnsmasq.d/50_docker_neo2
echo "host-record=neo3,$(docker inspect --format {{.NetworkSettings.IPAddress}} neo3)" | tee dns/dnsmasq.d/50_docker_neo3

# Check your host ports forwared to 7474 for each nodes
docker ps

# For each forwared port go to
http://localhost:<FORWARDED_PORT>/webadmin/#/info/org.neo4j/High%20Availability/
```

## Helper

`WARNING: Before you proceed, be aware the 'clear' argument kills and rm all docker containers !`

For convinience, you can use the helper.sh file to remove old or running container, build new images
start the new containers and/or check the cluster configuration.

Arguments :
- `clear`: kill running containers + remove all containers
- `clear:all`: same as `clear` + remove untagged/dangled images
- `build`: build `ekino/dnsmasq` and `ekino/neo4j-cluster` images
- `run:X`: run X containers

Arguments can be added to the commandline. They will be processed in order.

```bash
# The all in one command (/!\ it remove all your containers /!\)
./helper.sh clear:all build run:3
```

## Usage

Open your browser to http://localhost:7474

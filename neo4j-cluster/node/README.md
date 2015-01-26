# ekino/neo4j-cluster

## Init Cluster

Cluster nodes needs to talk to each other. So either we use etcd (or
similar project) or we use dnsmasq. This README only talks about this simple
poor's man approach using dnsmasq.

Start 1 master, then start each slave with explicit link to the master
(Auto-discovery will do the rest)

```bash
docker build -t ekino/neo4j-cluster:latest .
# local cluster nodes
docker run --name neo1 -d -e SERVER_ID=1 -p 7474:7474     ekino/neo4j-cluster:latest
docker run --name neo2 -d -e SERVER_ID=2 --link neo1:neo1 ekino/neo4j-cluster:latest
docker run --name neo3 -d -e SERVER_ID=3 --link neo1:neo1 ekino/neo4j-cluster:latest
# remote cluster nodes (ex: if master ip is 1.2.3.4 and one other node is 5.6.7.8)
docker run --name neo4 -d -e SERVER_ID=4 -e CLUSTER_NODES='1.2.3.4,5.6.7.8' ekino/neo4j-cluster:latest
```

## Usage

Open your browser to http://localhost:7474

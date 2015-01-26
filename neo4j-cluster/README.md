# ekino/neo4j-cluster

## Init Cluster

```
docker kill $(docker ps | awk 'NR!=1{print $1}')
docker rm $(docker ps -a| awk 'NR!=1{print $1}')
docker build -t=ekino/neo4j-cluster:first .
docker run --name neox -h neox -d -e SERVER_ID=1 -p 7474:7474 -P ekino/neo4j-cluster:first
docker ps

c=$(docker ps -l | awk 'NR!=1{print $1}')
docker logs $c
echo "==> Waiting 10s for Neo4j service to be up & running"
sleep 10
docker exec -ti $c curl http://localhost:7474
```

One line Copy/Paste :
er kill $(docker ps | awk 'NR!=1{print $1}'); docker rm $(docker ps -a| awk 'NR!=1{print $1}') ; docker build -t=ekino/neo4j-cluster:first . ; docker run --name neox -h neox -d -e SERVER_ID=1 -p 7474:7474 -P ekino/neo4j-cluster:first; docker ps ; c=$(docker ps -l | awk 'NR!=1{print $1}') ; docker logs $c ; echo "==> Waiting 10s for Neo4j service to be up & running" ; sleep 10 ; docker exec -ti $c curl http://localhost:7474
```


## Usage

Open your browser to http://localhost:7474

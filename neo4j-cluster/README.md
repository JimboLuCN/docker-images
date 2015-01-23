# ekino/neo4j-cluster

## Init Cluster

Start 1 master, then start each slave with explicit link to the master
(Auto-discovery will do the rest)

```bash
docker build -t ekino/neo4j-cluster:latest .
docker run --name neo1 -d -e SERVER_ID=1 -p 7474:7474     ekino/neo4j-cluster:latest
docker run --name neo2 -d -e SERVER_ID=2 --link neo1:neo1 ekino/neo4j-cluster:latest
docker run --name neo3 -d -e SERVER_ID=3 --link neo1:neo1 ekino/neo4j-cluster:latest
```

## Usage

Open your browser to http://localhost:7474

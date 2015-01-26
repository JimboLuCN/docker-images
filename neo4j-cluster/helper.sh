#!/bin/bash
#set -x

cnf='dns/dnsmasq.d'

for args in $@
do
  case ${1%:*} in
    'build')
      docker build -t=ekino/dnsmasq:latest dns/
      docker build -t=ekino/neo4j-cluster:latest node/
      ;;
    'run')
      mkdir -p $cnf
      # Start local DNS server
      echo "==> Starting DNS server"
      docker run --name neodns -h neodns -v $(readlink -f $cnf):/etc/dnsmasq.d -d ekino/dnsmasq:latest
      localdns=$(docker inspect --format {{.NetworkSettings.IPAddress}} neodns)

      # From Neo4j manual : minimum 3 nodes is required => either start arbiter or call "run:3"
      echo "==> Starting Neo4j cluster nodes + Registering to DNS server"
      for i in $(seq 1 ${1#*:})
      do
        # Create new cluster node
        echo "--> Run node 'neo$i'"
        docker run --name neo$i -h neo$i --dns $localdns -e SERVER_ID=$i -P -d ekino/neo4j-cluster:latest
        # Add new node to DNS server
        echo "--> Register node 'neo$i'"
        echo "host-record=neo$i,$(docker inspect --format {{.NetworkSettings.IPAddress}} neo$i)" | tee $cnf/50_docker_neo$i
        # Verify main settings
        echo "--> Verify main settings for 'neo$i'"
        docker logs neo$i
      done

      # Restart DNS server to register new nodes
      echo "==> Restarting DNS service"
      docker exec neodns supervisorctl restart dnsmasq

      # Wait.. and check last started node
      w=45
      echo "==> Waiting ${w}s (cluster warmup)"
      sleep $w
      docker exec -ti $(docker ps -l | awk 'NR!=1{print $1}') curl http://localhost:7474

      # Display webadmin URLs
      echo "==> Check each node's HA setup and availability using urls below"
      for i in $(docker ps | grep 7474 | sed -r 's/.*:(.....)->7474.*/\1/')
      do
        echo "http://localhost:$i/webadmin/#/info/org.neo4j/High%20Availability/"
      done
      ;;
    'clear')
      docker kill $(docker ps | awk 'NR!=1{print $1}')
      docker rm $(docker ps -a| awk 'NR!=1{print $1}')
      rm -f $cnf/*
      [ "${1#*:}" = "all" ] && docker rmi $(docker images -f dangling=true | awk 'NR!=1{print $3}')
      ;;
  esac
  shift
done

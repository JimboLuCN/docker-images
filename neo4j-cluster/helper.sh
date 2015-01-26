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
      localdns=$(docker inspect --format {{.NetworkSettings.IPAddress}} `docker ps -l | awk 'NR!=1{print $1}'`)

      # From Neo4j manual : minimum 3 nodes is required => either start arbiter or call "run:3"
      echo "==> Starting Neo4j cluster nodes + Registering to DNS server"
      for i in $(seq 1 ${1#*:})
      do
        # Create new cluster node
        docker run --name neo$i -h neo$i --dns $localdns -e SERVER_ID=$i -P -d ekino/neo4j-cluster:latest
        # Add new node to DNS server
        newhost=$(docker inspect --format {{.Config.Hostname}} `docker ps -l | awk 'NR!=1{print $1}'`)
        echo "host-record=$newhost,$(docker inspect --format {{.NetworkSettings.IPAddress}} $newhost)" | tee $cnf/50_docker_$newhost
      done

      # Restart DNS server to register new nodes
      echo "==> Restarting DNS service"
      docker exec neodns supervisorctl restart dnsmasq

      # Wait.. and check last started node
      w=15
      echo "==> Waiting ${w}s for cluster to start"
      sleep $w
      set -x
      docker exec -ti $(docker ps -l | awk 'NR!=1{print $1}') curl http://localhost:7474
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

#!/bin/bash

set -x

# Check of env variable. Complains+Help if missing
if [ -z "$SERVER_ID" ]; then
  echo >&2 "--------------------------------------------------------------------------------"
  echo >&2 "- Missing mandatory SERVER_ID ( for example : docker run -e SERVER_ID=2 .... ) -"
  echo >&2 "--------------------------------------------------------------------------------"
  exit 1
fi

# Customize config
CONFIG_FILE=/etc/neo4j/neo4j.properties

sed -i 's/SERVER_ID/'$SERVER_ID'/' $CONFIG_FILE

if [ "$SERVER_ID" = "1" ]; then
  # All this node to init the cluster all alone (initial_hosts=127.0.0.1)
  sed -i '/^ha.allow_init_cluster/s/false/true/' $CONFIG_FILE
else
  # Add exlicititely linked container (--link)
  # let autodiscovery do the rest
  # (possible since neo4j HA now uses Paxos http://fr.wikipedia.org/wiki/Paxos_(informatique) )
  for i in $(env | grep PORT_5001_TCP_ADDR)
  do
    nodename=${i,,}
    sed -i '/^ha.initial_hosts/s/$/,'${nodename%%_*}':5001/' $CONFIG_FILE
  done

  # TODO: allow remote neo4j container (use ENVs instead of links...)
  OIFS=$IFS
  if [ ! -z "$CLUSTER_NODES" ]; then
    IFS=','
    for i in $CLUSTER_NODES
    do
      sed -i '/^ha.initial_hosts/s/$/,'${i%%_*}':5001/' $CONFIG_FILE
    done
  fi
  IFS=$OIFS
fi

#sed -i 's/^#\(org.neo4j.server.database.mode=\)/\1/' /etc/neo4j/neo4j-server.properties

if [ "$REMOTE_HTTP" = "true" ]; then
  sed -i '/org.neo4j.server.webserver.address/s/^#//' $CONFIG_FILE
fi

if [ "$REMOTE_SHELL" = "true" ]; then
  sed -i '/remote_shell_enabled/s/^#//' /etc/neo4j/neo4j.properties
fi

# Start server

supervisord -n

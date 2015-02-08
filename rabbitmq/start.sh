#!/bin/bash

#set -x

echo "
      _    _
  ___| | _(_)_ __   ___
 / _ \ |/ / | '_ \ / _ \ 
|  __/   <| | | | | (_) |
 \___|_|\_\_|_| |_|\___(_)

"

#exec /usr/sbin/rabbitmq-server
# Start server
supervisord -n

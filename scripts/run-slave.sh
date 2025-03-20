# !/bin/bash

# Now, start YARN resource manager and redirect output to the logs
echo "Starting YARN node manager"
sudo $HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager > ./start-yarn-node.log 2>&1 &

# !/bin/bash

echo "Starting HDFS"
sudo $HADOOP_HOME/sbin/start-dfs.sh > ./start-dfs.log
# Now, start YARN resource manager and redirect output to the logs
echo "Starting YARN resource manager"
sudo $HADOOP_HOME/sbin/start-yarn.sh > ./start-yarn-resource.log 2>&1 &
sudo $HADOOP_HOME/bin/hdfs dfs -mkdir -p /shared/spark-logs
sudo $HADOOP_HOME/bin/hdfs dfs -mkdir -p /tmp
sudo $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/hive/warehouse
sudo $HADOOP_HOME/bin/hdfs dfs -chmod -R 777 /
sudo $HADOOP_HOME/bin/hdfs dfs -chmod -R 777 /tmp
sudo $HADOOP_HOME/bin/hdfs dfs -chmod -R 777 /user/hive/
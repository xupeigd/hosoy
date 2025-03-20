# !/bin/bash

echo "Waiting For Mysql ~"
sleep 60
echo "Starting metastore ! "
$HIVE_HOME/bin/schematool --dbType mysql -initSchema
$HIVE_HOME/bin/hive --service metastore >> ~/metastore.log &
# !/bin/bash
export VERSION_HADOOP=3.3.2
export VERSION_HIVE=3.1.3
export VERSION_SPARK=3.3.2
echo "https://archive.apache.org/dist/hadoop/common/hadoop-${VERSION_HADOOP}/hadoop-${VERSION_HADOOP}.tar.gz"
curl -OL "https://archive.apache.org/dist/hadoop/common/hadoop-${VERSION_HADOOP}/hadoop-${VERSION_HADOOP}.tar.gz"

echo "https://archive.apache.org/dist/hive/hive-${VERSION_HIVE}/apache-hive-${VERSION_HIVE}-bin.tar.gz"
curl -OL "https://archive.apache.org/dist/hive/hive-${VERSION_HIVE}/apache-hive-${VERSION_HIVE}-bin.tar.gz"

echo "https://archive.apache.org/dist/spark/spark-${VERSION_SPARK}/spark-${VERSION_SPARK}-bin-hadoop3.tgz"
curl -OL "https://archive.apache.org/dist/spark/spark-${VERSION_SPARK}/spark-${VERSION_SPARK}-bin-hadoop3.tgz"

docker pull ubuntu:22.04
docker pull mysql:8.0
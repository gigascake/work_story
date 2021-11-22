mkdir -p /raid/kafka-cluster/zookeeper/zoo1/conf
mkdir -p /raid/kafka-cluster/zookeeper/zoo1/data
mkdir -p /raid/kafka-cluster/zookeeper/zoo1/log
mkdir -p /raid/kafka-cluster/broker1/data
mkdir -p /raid/kafka-cluster/broker2/data
mkdir -p /raid/kafka-cluster/broker3/data
mkdir -p /raid/kafka-cluster/control-center/data
mkdir -p /raid/kafka-cluster/broker1/conf
mkdir -p /raid/kafka-cluster/broker2/conf
mkdir -p /raid/kafka-cluster/broker3/conf
chown -R hadoop:hadoop /raid/kafka-cluster


docker stop zookeeper1 
docker stop broker1 
docker stop schema-registry 
docker stop connect 
docker stop ksqldb-server 
docker stop ksqldb-cli
docker stop ksql-datagen
docker stop control-center
docker stop rest-proxy

docker container rm zookeeper1 
docker container rm broker1 
docker container rm schema-registry 
docker container rm connect 
docker container rm ksqldb-server 
docker container rm ksqldb-cli
docker container rm ksql-datagen
docker container rm control-center
docker container rm rest-proxy


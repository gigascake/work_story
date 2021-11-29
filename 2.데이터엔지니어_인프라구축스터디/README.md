# Kafka DB가 과연 성능이 나올까?
# Kafka DB Vs Kudu+Impal DB의 성능비교를 위한 구축 및 테스트 작업
# 모회사의 키워드 : Kafka 토픽이 많으면 느려진다. 원인이 무엇일까? 해결책은?

## 1. 테스트 환경 구축
## 1) Docker로 카프카노드를 broker 3개로 구축한다.
## 2) 복제노드는 2개로 설정한다.
## 3) KSQL엔진을 연결하여 DB처럼 사용한다.
## 4) 카프카 성능 테스트하는 방법을 준비한다.
## 5) 주식데이터를 저장한다.
## 6) 국내주식데이터를 모두넣어보고 Topic의 개수가 어느정도늘어나는 시점에서 카프카의 성능이 느려지는지 확인한다.



## 2. TEST환경 서버.
### 1) Kafka Streamining Database 환경.
####  CPU : AMD 5950x
####  RAM : 128G
####  SSD : 10TB + 512G

#### docker run으로는 자원제한이 가능한데 docker-compose로 자원제한하는 법은 모르겠다.
####  kafka Node당 각 : RAM 24G, 2TB 할당.
####  schema-registry : RAM 12G, 1TB 할당.
####  zookeeper1 : 8G, 64G 할당.
####  나머지 6개노드  : Active



### 3. docker-compose 관련 디렉토리 생성. (분산디스크 구축완료: B550보드라 GEN4 NVME 2개만 장착할 수 있다. B550칩셋이 최신칩셋이라고 태깅하고 있는 다나와 관계자들 미워요.)

#### ( X570 보드를 사느냐, PCI-NVMe컨버터로 남은 GEN3 nvme를 추가장착가능하느냐 기로에 서있다. NVME GEN4 하나 남는다. 개봉했다. ㅠ - [2021-11-24] )
#### mkdir -p /raid03/kafka-cluster/zookeeper/zoo1/conf
#### mkdir -p /raid03/kafka-cluster/zookeeper/zoo1/data
#### mkdir -p /raid03/kafka-cluster/zookeeper/zoo1/log
#### mkdir -p /raid01/kafka-cluster/broker1/data
#### mkdir -p /raid02/kafka-cluster/broker2/data
#### mkdir -p /raid03/kafka-cluster/broker3/data
#### mkdir -p /raid03/kafka-cluster/control-center/data
#### mkdir -p /raid01/kafka-cluster/broker1/conf
#### mkdir -p /raid02/kafka-cluster/broker2/conf
#### mkdir -p /raid03/kafka-cluster/broker3/conf
#### mkdir -p /raid03/kafka-cluster/ksqldb-cli/bin
#### chown -R hadoop:hadoop /raid01/kafka-cluster
#### chown -R hadoop:hadoop /raid02/kafka-cluster
#### chown -R hadoop:hadoop /raid03/kafka-cluster


### 4. docker-compose 구성실패시 초기화

#### docker stop zookeeper1 
#### docker stop broker1 
#### docker stop schema-registry 
#### docker stop connect 
#### docker stop ksqldb-server 
#### docker stop ksqldb-cli
#### docker stop ksql-datagen
#### docker stop control-center
#### docker stop rest-proxy

#### docker container rm zookeeper1 
#### docker container rm broker1 
#### docker container rm schema-registry 
#### docker container rm connect 
#### docker container rm ksqldb-server 
#### docker container rm ksqldb-cli
#### docker container rm ksql-datagen
#### docker container rm control-center
#### docker container rm rest-proxy

### 5. docker-compose 실행
docker-compose up -d



# 6. docker ps -a
#### CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS          
#### 7af6e1c295f8   confluentinc/ksqldb-examples:7.0.0                "bash -c 'echo Waiti…"   14 minutes ago   Up 14 minutes   
#### 1f0d9b74ba59   confluentinc/cp-enterprise-control-center:7.0.0   "/etc/confluent/dock…"   14 minutes ago   Up 14 minutes   
#### c6545b12d2ff   confluentinc/cp-ksqldb-cli:7.0.0                  "/bin/bash"              14 minutes ago   Up 14 minutes   
#### fe616e7a9673   confluentinc/cp-ksqldb-server:7.0.0               "/etc/confluent/dock…"   14 minutes ago   Up 14 minutes   
#### 8eb5f6fac82b   cnfldemos/cp-server-connect-datagen:0.5.0-6.2.0   "/etc/confluent/dock…"   14 minutes ago   Up 14 minutes   
#### f23f631c909b   confluentinc/cp-kafka-rest:7.0.0                  "/etc/confluent/dock…"   43 minutes ago   Up 43 minutes   
#### 25d7165d8a26   confluentinc/cp-schema-registry:7.0.0             "/etc/confluent/dock…"   43 minutes ago   Up 43 minutes   
#### 324af21eb7f9   confluentinc/cp-kafka:7.0.0                       "/etc/confluent/dock…"   43 minutes ago   Up 43 minutes   
#### ab59ab49b5fe   confluentinc/cp-kafka:7.0.0                       "/etc/confluent/dock…"   43 minutes ago   Up 43 minutes   
#### 61ce868a9d31   confluentinc/cp-kafka:7.0.0                       "/etc/confluent/dock…"   43 minutes ago   Up 43 minutes   
#### 7a710a4f72a5   confluentinc/cp-zookeeper:7.0.0                   "/etc/confluent/dock…"   43 minutes ago   Up 43 minutes   


# 7. Streams API와 Ksql 사용법 정리
#### 1) Streams API는 Streams에 대해 필터의 역할이 대부분인거 같다.기존에 Telegraf와 Logstash를 사용할줄 아는 나에게 있어, 용도의 차이는 그닥 없어 보인다. 성능의 차이는 추후 확인해봐야겠다.
#### 2) Ksql은 ksql-python 라이브러리로 파이썬에서도 제어가 가능하다. 얼마만큼 기존 SQL을 대체할 수 있는지는 사용하면서 차이점을 비교해봐야겠다.
#### 3) 정복해야할 KsqlDB Query Usage: 
#### - https://docs.ksqldb.io/en/latest/reference/sql/appendix/

# 8. HUE 설치
https://github.com/cloudera/hue/tree/master/tools/docker/hue 

docker run -it -p 8888:8888 gethue/hue:latest

# 8. HUE와 KSQLDB 연동하기.


와 9. HUe와 KUDU & Impala연동하기.


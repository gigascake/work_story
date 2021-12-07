## cdh6-hue-impala-kudu 세팅
## HUE, IMPALA, KUDU 세팅을 완료한 후, KSQLDB을  연동하여 , REMOTE CONTROL 환경을 구축한다.
##
## Docker Image 설치 후 HUE와 연동한다. 연동 전 포트를 점검하여 서비스가 정상가동 중인지 체크한다.
## CDH6 오픈소스가 막힌 관계로, 아래의 Docker Image를 Base로 하여, HUE 소스를 컴파일하여 별도의 Docker Image를 만들었다.
## https://hub.docker.com/r/fedormalyshkin/cdh6-impala-kudu
#### Exposed ports
#### [Active]    7050 [EXT] - Apache Kudu. TabletServer. Kudu TabletServer RPC         
#### [Active]    7051 [EXT] - Apache Kudu. Master. Kudu Master RPC port                
#### [Active]    8020 [INT] - Apache Hadoop HDFS. NameNode. fs.defaultFS               
#### [Active]    8050 [EXT] - Apache Kudu. TabletServer. Kudu TabletServer HTTP server port   
#### [Active]    8051 [EXT] - Apache Kudu. Master. Kudu Master HTTP server port        
#### [No Active] 9083 [INT] - Apache Hive. Metastore.   
#### [No Active]21000 [EXT] - Apache Impala. Impala Daemon. Used to transmit commands and receive results by impala-shell and version 1.2 of the Cloudera ODBC driver.  
#### [No Active]21050 [EXT] - Apache Impala. Impala Daemon. Used to transmit commands and receive results by applications, such as Business Intelligence tools, using JDBC, the Beeswax query editor in Hue, and version 2.0 or higher of the Cloudera ODBC driver.
#### [No Active]22000 [INT] - Apache Impala. Impala Daemon. Internal use only. Impala daemons use this port to communicate with each other.
#### [Active]   23000 [INT] - Apache Impala. Impala Daemon. Internal use only. Impala daemons listen on this port for updates from the statestore daemon.
#### [No Active]23020 [INT] - Apache Impala. Catalog Daemon. Internal use only. The catalog daemon listens on this port for updates from the statestore daemon.
#### [Active]   24000 [INT] - Apache Impala. StateStore Daemon. Internal use only. The statestore daemon listens on this port for registration/unregistration requests.
#### [Active]   25000 [EXT] - Apache Impala. Impala Daemon. Impala web interface for administrators to monitor and troubleshoot.
#### [Active]   25010 [EXT] - Apache Impala. StateStore Daemon. StateStore web interface for administrators to monitor and troubleshoot.
#### [No Active]25020 [EXT] - Apache Impala. Catalog Daemon. Catalog service web interface for administrators to monitor and troubleshoot.
#### [No Active]26000 [INT] - Apache Impala. Catalog Daemon. Internal use only. The catalog service uses this port to communicate with the Impala daemons.
#### [No Active]50010 [INT] - Apache Hadoop HDFS. DataNode. dfs.datanode.address


root@175:/# netstat -ntlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:25000           0.0.0.0:*               LISTEN      490/impalad         
tcp        0      0 0.0.0.0:9864            0.0.0.0:*               LISTEN      225/java            
tcp        0      0 0.0.0.0:7050            0.0.0.0:*               LISTEN      669/kudu-tserver    
tcp        0      0 0.0.0.0:9866            0.0.0.0:*               LISTEN      225/java            
tcp        0      0 0.0.0.0:7051            0.0.0.0:*               LISTEN      521/kudu-master     
tcp        0      0 0.0.0.0:9867            0.0.0.0:*               LISTEN      225/java            
tcp        0      0 0.0.0.0:9870            0.0.0.0:*               LISTEN      75/java             
tcp        0      0 0.0.0.0:8050            0.0.0.0:*               LISTEN      669/kudu-tserver    
tcp        0      0 0.0.0.0:25010           0.0.0.0:*               LISTEN      374/statestored     
tcp        0      0 0.0.0.0:8051            0.0.0.0:*               LISTEN      521/kudu-master     
tcp        0      0 172.17.0.3:8020         0.0.0.0:*               LISTEN      75/java             
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      1063/python2.7      
tcp        0      0 0.0.0.0:23000           0.0.0.0:*               LISTEN      490/impalad         
tcp        0      0 127.0.0.1:34971         0.0.0.0:*               LISTEN      225/java            
tcp        0      0 0.0.0.0:24000           0.0.0.0:*               LISTEN      374/statestored 

#### [2021-11-29] 첩첩산중, HIVE Metastore가 연결되어 있지 않아서, HIVE가 구동이 안된다. docker image좀 제대로 만들지, 손 참 많이 가네...내가 제대로 만들어서 쓴다.
#### service --status-all
#### 로 서비스 상태체크를 한다.
####
#### 1) postgresql docker 설치
#### $ docker run --name postgres-dev -d --restart unless-stopped -p [CUSTOM_PORT]:5432 -e POSTGRES_PASSWoRD=[ADMIN_PASSWORD] \
####   -v /raid/postgres/data:/var/lib/postgresql/data postgres:13.3
####
#### 2) 구동 학인
#### $ docker logs postgres-dev
#### 
#### 3) bash 접속
#### $ docker exec -it postgres-container bash
####
#### 4) HUE 데이터베이스 생성.
#### 사용자계정이 없다면,($ psql)
####             ($ create user postgres with password 'postgres';)
#### $ psql -U postgres
#### $ create database metastore_db owner=postgres;
#### $ create schema authorization postgres;
#### $ \l


#### impala.
#### 
       <property>
                <name>dfs.namenode.name.dir</name>
                <value>file:///var/lib/hadoop-hdfs/cache/hdfs/dfs/name</value>
                <description>HDFS Namenode's fsimage directory (restore CDH default)</description>
        </property>

        <property>
                <name>dfs.datanode.data.dir</name>
                <value>file:///var/lib/hadoop-hdfs/cache/hdfs/dfs/data</value>
                <description>HDFS datanode's data directory</description>
        </property>

        <property>
                <name>dfs.replication</name>
                <value>1</value>
                <description>Default block replication (default = 3)</description>
        </property>

        <property>
                <name>dfs.client.read.shortcircuit</name>
                <value>true</value>
                <description>Turns on short-circuit local reads (default = false). Required for Impala.</description>
        </property>

        <property>
                <name>dfs.domain.socket.path</name>
                <value>/var/run/hdfs-sockets/dn</value>
                <description>
                        UNIX Socket Path that will be used for communication between the DataNode and local HDFS clients. (default = NULL). Required for Impala.
                </description>
        </property>

        <property>
                <name>dfs.client.file-block-storage-locations.timeout.millis</name>
                <value>10000</value>
                <description>
                        Timeout (in milliseconds) for the parallel RPCs made in DistributedFileSystem#getFileBlockStorageLocations() (default = 1000). Required for Impala.
                </description>
        </property>

        <property>
                <name>dfs.datanode.hdfs-blocks-metadata.enabled</name>
                <value>true</value>
                <description>
                        Enables backend datanode-side support for the experimental DistributedFileSystem#getFileVBlockStorageLocations API. (default = false). Required for Impala.
                </description>
        </property>

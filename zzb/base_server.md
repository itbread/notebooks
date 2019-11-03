## Haproxy 代理

### Haproxy(1.5.18)

#### 安装

```bash
yum install haproxy
```

#### 配置日志

在 haproxy 中默认指定日志设置为

```yaml
log         127.0.0.1 local2
```

我们需要对 rsyslog 进行配置使 haproxy 可以写日志文件

##### 编辑`/etc/rsyslog.conf`文件

解注释下列代码

```yaml
$ModLoad imudp
$UDPServerRun 514
```

在下列代码

```yaml
# Save boot messages also to boot.log
local7.*                                               /var/log/boot.log
```

添加

```yaml
local2.*                       /var/log/haproxy.log
```

##### 编辑`/etc/sysconfig/rsyslog`文件

```yaml
SYSLOGD_OPTIONS="-r -m 0 -c 2"
```

##### 重启 rsyslog 和 haproxy 服务

#### 编辑配置文件

配置文件位置 `/etc/haproxy/haproxy.cfg`

##### emp_portal

在配置文件中添加

```bash
frontend emp_portal_frontend
   #设置证书
   bind *:8888 ssl crt /opt/ssl/ca.pem
   mode http
   option httpclose
   option forwardfor
   reqadd X-Forwarded-Proto:\ https
   default_backend emp_portal

backend emp_portal
  mode http
  #简单的轮询
  balance roundrobin
  cookie SERVERID insert indirect nocache
  server emp_portal01 172.53.29.53:8088 check cookie emp_portal01
  server emp_portal02 172.53.29.54:8088 check cookie emp_portal02
  server emp_portal03 172.53.29.55:8088 check cookie emp_portal03
```

##### stu_mp_portal

```bash
frontend  stu_mp_portal_frontend
   #设置证书
   bind *:9443 ssl crt /opt/ssl/ca.pem
   mode http
   option httpclose
   option forwardfor
   reqadd X-Forwarded-Proto:\ https
   default_backend  stu_mp_portal

backend  stu_mp_portal
  mode http
  #简单的轮询
  balance roundrobin
  cookie SERVERID insert indirect nocache
  server stu_mp_portal01 172.53.29.53:8000 check cookie stu_mp_portal01
  server stu_mp_portal02 172.53.29.54:8000 check cookie stu_mp_portal02
  server stu_mp_portal03 172.53.29.55:8000 check cookie stu_mp_portal03
```

##### pgsql

在配置文件中添加

```bash
listen pgsql_cluster 0.0.0.0:19999
　　#配置TCP模式
　　mode tcp
　　option tcplog
　　#简单的轮询
　　balance roundrobin
　　#pgsql集群节点配置
　　server pg01 172.53.29.53:9999 check inter 5000 rise 2 fall 2
　　server pg02 172.53.29.54:9999 check inter 5000 rise 2 fall 2
     server pg03 172.53.29.55:9999 check inter 5000 rise 2 fall 2
```

##### micro api

```bash
listen micro_api_cluster 0.0.0.0:18080
    #配置HTTP模式
    mode http
    option httplog
    #简单的轮询
    balance roundrobin
    #micro api集群节点配置
    server micro01 172.53.29.53:8080 check inter 5000 rise 2 fall 2
    server micro02 172.53.29.54:8080 check inter 5000 rise 2 fall 2
    server micro03 172.53.29.55:8080 check inter 5000 rise 2 fall 2
```

##### redis

```bash
listen redis_cluster 0.0.0.0:6379
    #配置TCP模式
    mode tcp
    option tcplog
    #简单的轮询
    balance roundrobin
    #redis集群节点配置
    server redis01 172.53.29.53:7000 check inter 5000 rise 2 fall 2
    server redis02 172.53.29.53:7001 check inter 5000 rise 2 fall 2
    server redis03 172.53.29.54:7002 check inter 5000 rise 2 fall 2
    server redis04 172.53.29.54:7003 check inter 5000 rise 2 fall 2
    server redis05 172.53.29.55:7004 check inter 5000 rise 2 fall 2
    server redis06 172.53.29.55:7005 check inter 5000 rise 2 fall 2
```

##### seaweedfs

```bash
listen seaweedfs_cluster 0.0.0.0:19334
    #配置HTTP模式
    mode http
    option httplog
    #简单的轮询
    balance roundrobin
    #seaweedfs 集群节点配置
    server seaweedfs01 172.53.29.53:9333 check inter 5000 rise 2 fall 2
    server seaweedfs02 172.53.29.54:9333 check inter 5000 rise 2 fall 2
    server seaweedfs03 172.53.29.55:9333 check inter 5000 rise 2 fall 2
```

#### 启动

```bash
haproxy -f /etc/haproxy/haproxy.cfg
```

#### 重启

```bash
service haproxy restart
```

## 数据库

### redis(5.0.4)

#### 下载

```bash
wget http://download.redis.io/releases/redis-5.0.4.tar.gz
```

#### 安装

```bash
tar xzf redis-5.0.4.tar.gz
cd redis-5.0.4


make MALLOC=libc & make install
```

#### 创建 Redis 节点

在 /opt 目录下创建 redis_cluster 文件夹

```
mkdir redis_cluster
```

在第一台机器的 redis_cluster 目录下，创建 7000，7001 的目录，并将 redis-5.0.5 目录下的 redis.conf 拷到这三个目录

```bash
mkdir 7000 7001
cp redis.conf redis_cluster/7000
cp redis.conf redis_cluster/7001
```

#### 分别修改这两个配置文件，修改如下内容

```
port 7000 //端口7000,7001
bind 本机ip //默认ip为127.0.0.1 需要改为其他节点机器可访问的ip 否则创建集群时无法访问对应的端口，无法创建集群
daemonize yes //redis后台运行
pidfile /var/run/redis_7000.pid //pidfile文件对应7000,7001
logfile "/var/redis/redis_7000.log"
cluster-enabled yes //开启集群 把注释#去掉
cluster-config-file nodes-7000.conf //集群的配置 配置文件首次启动自动生成 7000,7001
cluster-node-timeout 15000 //请求超时 默认15秒，可自行设置
appendonly yes //aof日志开启 有需要就开启，它会每次写操作都记录一条日志　
dbfilename dump.rdb //写文件的文件名
dir /var/lib/redis/7000  //文件路径

```

`所有设置的目录如果不存在，都需要自己创建`

#### 另两台机器设置

接着在另外一台机器上（172.53.29.54,172.53.29.55,），的操作重复以上三步，只是把目录改为 7002，7003、7004、7005，对应的配置文件也按照这个规则修改即可

#### 启动各个节点

redis 安装在 `/usr/local/bin`目录下，如果 PATH 没有此路径，可以添加`export PATH=$PATH:/usr/local/bin` 到`.bashrc` 或 `/etc/profile` 文件中

- 第一台机器上执行

```bash
redis-server /opt/redis_cluster/7000/redis.conf
redis-server /opt/redis_cluster/7001/redis.conf
```

- 另外两台机器上执行

```bash
redis-server /opt/redis_cluster/7002/redis.conf
redis-server /opt/redis_cluster/7003/redis.conf
```

```bash
redis-server /opt/redis_cluster/7004/redis.conf
redis-server /opt/redis_cluster/7005/redis.conf
```

#### 检查 redis 启动情况

```bash
netstat -tnlp | grep redis
```

#### 创建集群

- 先创建只有 3 个不带从节点的集群

```bash
redis-cli --cluster create 172.53.29.53:7000  172.53.29.54:7002 172.53.29.55:7004 --cluster-replicas 0
```

- 查看节点(时有时无，加完从节点后稳定,需要在 haproxy 配置好 6379 代理之后)

```bash
[server1]#
[server1]# redis-cli cluster nodes
7889ed2ec256faa42f2771e0ab0ff98209b2a359 172.53.29.54:7002@17002 master - 0 1568531599248 2 connected 5461-10922
8ff0c803dd63e2bfb3f68f163c0e24a71a41e802 172.53.29.55:7004@17004 master - 0 1568531600249 3 connected 10923-16383
748058cb7ede2d272a823325272f5eac5a2068eb 172.53.29.53:7000@17000 myself,master - 0 1568531599000 1 connected 0-5460
```

- 添加 slave 节点(进行环型备份，从节点与主节点不在同一台机上，形成一个环)

```bash
redis-cli --cluster add-node 172.53.29.53:7001 172.53.29.55:7004 --cluster-slave --cluster-master-id 8ff0c803dd63e2bfb3f68f163c0e24a71a41e802
redis-cli --cluster add-node 172.53.29.54:7003 172.53.29.53:7000 --cluster-slave --cluster-master-id 748058cb7ede2d272a823325272f5eac5a2068eb
redis-cli --cluster add-node 172.53.29.55:7005 172.53.29.54:7002 --cluster-slave --cluster-master-id 7889ed2ec256faa42f2771e0ab0ff98209b2a359
```

- 要修改可以先删除

```bash
redis-cli --cluster del-node 172.53.29.54:7003 748058cb7ede2d272a823325272f5eac5a2068eb
```

同时需要删除 nodes-7003.conf 文件

- 若主节点宕机，从节点会替换主节点，主节点恢复后会成为从节点，想要恢复成主节点则可以把原从节点升级成为的主节关闭，会重新将由原主节点变成的从节点升级为主节点

#### 进入控制台测试

redis-cli -c -h yourhost -p yourport

### seaweedfs(1.32)

#### 下载 tar 包

```bash
wget https://github.com/chrislusf/seaweedfs/releases/download/1.32/linux_amd64.tar.gz
```

#### 解压安装

```bash
tar -xvf linux_amd64.tar.gz -C /usr/local/bin/
```

#### 启动

在相应的机器下创建下列文件夹

```bash
[server1] /opt/seaweedfs/master1
[server2] /opt/seaweedfs/master2
[server3] /opt/seaweedfs/master3
[server1] /opt/seaweedfs/volume1
[server1] /opt/seaweedfs/volume2
[server2] /opt/seaweedfs/volume3
[server2] /opt/seaweedfs/volume4
[server3] /opt/seaweedfs/volume5
[server3] /opt/seaweedfs/volume6
```

##### master

```bash
nohup weed  -logdir="/opt/seaweedfs/log"  master   -mdir="/opt/seaweedfs/master1" -ip="172.53.29.53" -ip.bind="172.53.29.53" -port=9333 -peers="172.53.29.53:9333,172.53.29.54:9333,172.53.29.55:9333"  -defaultReplication="110" > /dev/null &

nohup weed   -logdir="/opt/seaweedfs/log"  master   -mdir="/opt/seaweedfs/master2" -ip="172.53.29.54" -ip.bind="172.53.29.54" -port=9333 -peers="172.53.29.53:9333,172.53.29.54:9333,172.53.29.55:9333"  -defaultReplication="110" > /dev/null &

nohup weed   -logdir="/opt/seaweedfs/log" master   -mdir="/opt/seaweedfs/master3" -ip="172.53.29.55" -ip.bind="172.53.29.55" -port=9333 -peers="172.53.29.53:9333,172.53.29.54:9333,172.53.29.55:9333"  -defaultReplication="110" > /dev/null  & # 最好有三台机器，为了防止脑裂，只允许奇数个master
```

##### volume

一个 datacenter 要两个 rack

```bash
nohup weed   -logdir="/opt/seaweedfs/log" volume -dataCenter="m5dc1"  -rack="m5rack1"  -ip="172.53.29.53" -ip.bind="172.53.29.53" -max="10" -dir="/opt/seaweedfs/volume1"  -mserver="172.53.29.53:9333" -port=8081 > /dev/null  &

nohup weed   -logdir="/opt/seaweedfs/log"  volume -dataCenter="m5dc1"  -rack="m5rack2"  -ip="172.53.29.53" -ip.bind="172.53.29.53" -max="10" -dir="/opt/seaweedfs/volume2"  -mserver="172.53.29.53:9333" -port=8082 > /dev/null &

nohup weed  -logdir="/opt/seaweedfs/log"  volume -dataCenter="m5dc2"  -rack="m5rack1"  -ip="172.53.29.54" -ip.bind="172.53.29.54" -max="10" -dir="/opt/seaweedfs/volume3"  -mserver="172.53.29.54:9333" -port=8081 > /dev/null &

nohup weed  -logdir="/opt/seaweedfs/log"   volume -dataCenter="m5dc2"  -rack="m5rack2"  -ip="172.53.29.54" -ip.bind="172.53.29.54" -max="10" -dir="/opt/seaweedfs/volume4"  -mserver="172.53.29.54:9333" -port=8082 > /dev/null &

nohup weed  -logdir="/opt/seaweedfs/log"   volume -dataCenter="m5dc3"  -rack="m5rack1"  -ip="172.53.29.55" -ip.bind="172.53.29.55" -max="10" -dir="/opt/seaweedfs/volume5"  -mserver="172.53.29.55:9333" -port=8081 > /dev/null &

nohup weed  -logdir="/opt/seaweedfs/log"   volume -dataCenter="m5dc3"  -rack="m5rack2"  -ip="172.53.29.55" -ip.bind="172.53.29.55" -max="10" -dir="/opt/seaweedfs/volume6"  -mserver="172.53.29.55:9333" -port=8082 > /dev/null &
```

### PGPOOLII + Postgresql 安装布署

参考：[https://www.pgpool.net/docs/latest/en/html/example-cluster.html](https://www.pgpool.net/docs/latest/en/html/example-cluster.html)

#### 在 postgres(在哪个用户下运行就在哪个用户配置)用户下配置免密码登录（所有节点）

为 pgxc_ctl 配置 ssh 免密码登录

```bash
[all servers]# cd ~/.ssh
[all servers]# ssh-keygen -t rsa -f id_rsa_pgpool
[all servers]# ssh-copy-id -p 32200 -i id_rsa_pgpool.pub postgres@server1
[all servers]# ssh-copy-id -p 32200  -i id_rsa_pgpool.pub postgres@server2
[all servers]# ssh-copy-id -p 32200  -i id_rsa_pgpool.pub postgres@server3

[all servers]# su - postgres
[all servers]$ cd ~/.ssh
[all servers]$ ssh-keygen -t rsa -f id_rsa_pgpool
[all servers]$ ssh-copy-id -p 32200 -i id_rsa_pgpool.pub postgres@server1
[all servers]$ ssh-copy-id -p 32200 -i id_rsa_pgpool.pub postgres@server2
[all servers]$ ssh-copy-id -p 32200 -i id_rsa_pgpool.pub postgres@server3
```

#### 安装

##### Postgresql(11)

```bash
# yum install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
# yum install postgresql11 postgresql11-libs postgresql11-devel postgresql11-server
```

##### Pgpool-II(4.0.1)

```bash
# yum install http://www.pgpool.net/yum/rpms/4.0/redhat/rhel-7-x86_64/pgpool-II-release-4.0-1.noarch.rpm
# yum install pgpool-II-pg11-*
```

##### 设置环境变量

在 postgres 用户下 修改 .bashrc

```bash
export PGDATA=/var/lib/pgsql/11/data
export PGBIN=/usr/pgsql-11/bin
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:$PGHOME/bin:$PGBIN
```

#### 规划

| 主机名  |      IP      |   角色   | 端口 |
| :-----: | :----------: | :------: | :--- |
| server1 | 172.53.29.53 | PGMaster | 5432 |
|         | 172.53.29.53 | pgpool1  | 9999 |
| server2 | 172.53.29.54 | PGSlave  | 5432 |
|         | 172.53.29.54 | pgpool2  | 9999 |
| server3 | 172.53.29.55 | PGSlave  | 5432 |
|         | 172.53.29.55 | pgpool3  | 9999 |

#### 修改 Host(所有节点)

```bash
172.53.29.53 server1
172.53.29.54 server2
172.53.29.55 server3
```

#### 修改 hostname(所有节点)

- /etc/sysconfig/network

```
vim /etc/sysconfig/network
```

```
HOSTNAME=server1
```

- /etc/hosts

将如下内容

```
vim /etc/hosts
```

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

修改为

```
127.0.0.1   localhost server1 localhost4 localhost4.localdomain4
::1         localhost server1 localhost6 localhost6.localdomain6
```

- /etc/hostname

```
 vi /etc/hostname
```

```
server1
```

#### 设置 postgresql 流复制

- 创建 `/var/lib/pgsql/archivedir`

```bash
[all servers]# su - postgres
[all servers]$ mkdir /var/lib/pgsql/archivedir
```

- 主节点初始化

```bash
initdb -D $PGDATA
```

- 启动主节点数据库

```bash
pg_ctl start -D $PGDATA
```

- 修改主节点配置文件  `$PGDATA/postgresql.conf`

```yaml
listen_addresses = '*'
port = 5432
archive_mode = on
archive_command = 'cp "%p" "/var/lib/pgsql/archivedir/%f"'
max_wal_senders = 10
max_replication_slots = 10
wal_level = replica
```

#### 创建流复制用户

```bash
[server1]# psql -U postgres -p 5432
```

```sql
 SET password_encryption = 'md5';
 CREATE ROLE pgpool WITH LOGIN;
 CREATE ROLE repl WITH REPLICATION LOGIN;
 \password pgpool
 \password repl
 \password postgres
```

| user name | password |
| --------- | -------- |
| pgpool    | pgpool   |
| repl      | repl     |
| postgres  | postgres |

#### 修改 /var/lib/pgsql/11/data/pg_hba.conf(不要留其它选项)

```bash
host    all             all             samenet                 md5
host    replication     all             samenet                 md5
```

#### 免密码(如果设置密码)

在 /home/postgres 目录下创建.pgpass 文件
添加对应密码即可,格式 hostname:port:database:username:password

```bash
server1:5432:replication:repl:repl
server2:5432:*:repl:repl
server3:5432:*:repli:repl
server1:5432:*:postgres:postgres
server2:5432:*:postgres:postgres
server3:5432:*:postgres:postgres
```

chmod 600 .pgpass

更新时要用`pg_ctl reload`生效

#### PGPOOLII 设置

##### 修改 pgpool.conf（每个节点一样）

拷贝配置文件

```
# cp /etc/pgpool-II/pgpool.conf.sample-stream /etc/pgpool-II/pgpool.conf
```

修改配置文件

- 修改监听

```
listen_addresses = '*'
```

- 指定 replication delay 检查用户及密码

```
sr_check_user = 'pgpool'
sr_check_password = 'pgpool'
```

- 心跳检查

```
health_check_period = 5
                                   # Health check period
                                   # Disabled (0) by default
health_check_timeout = 30
                                   # Health check timeout
                                   # 0 means no timeout
health_check_user = 'pgpool'
health_check_password = 'pgpool'

health_check_max_retries = 3
```

- PostgreSQL  后端设置

```
backend_hostname0 = 'server1'
                                   # Host name or IP address to connect to for backend 0
backend_port0 = 5432
                                   # Port number for backend 0
backend_weight0 = 1
                                   # Weight for backend 0 (only in load balancing mode)
backend_data_directory0 = '/var/lib/pgsql/11/data'
                                   # Data directory for backend 0
backend_flag0 = 'ALLOW_TO_FAILOVER'
                                   # Controls various backend behavior
                                   # ALLOW_TO_FAILOVER or DISALLOW_TO_FAILOVER
backend_hostname1 = 'server2'
backend_port1 = 5432
backend_weight1 = 1
backend_data_directory1 = '/var/lib/pgsql/11/data'
backend_flag1 = 'ALLOW_TO_FAILOVER'

backend_hostname2 = 'server3'
backend_port2 = 5432
backend_weight2 = 1
backend_data_directory2 = '/var/lib/pgsql/11/data'
backend_flag2 = 'ALLOW_TO_FAILOVER'

```

- failover 设置

```
failover_command = '/etc/pgpool-II/failover.sh %d %h %p %D %m %H %M %P %r %R'
follow_master_command = '/etc/pgpool-II/follow_master.sh %d %h %p %D %m %M %H %P %r %R'
```

- 在线恢复设置

```
recovery_user = 'postgres'
                                   # Online recovery user
recovery_password = 'postgres'
                                   # Online recovery password

recovery_1st_stage_command = 'recovery_1st_stage'
```

- 客户端权限

```
enable_pool_hba = on
```

- 看门狗

```
use_watchdog = on


wd_hostname = 'server1'   ## 本机对应的server
wd_port = 9000


# - Other pgpool Connection Settings -

other_pgpool_hostname0 = 'server2'
                                    # Host name or IP address to connect to for other pgpool 0
                                    # (change requires restart)
other_pgpool_port0 = 9999
                                    # Port number for other pgpool 0
                                    # (change requires restart)
other_wd_port0 = 9000
                                    # Port number for other watchdog 0
                                    # (change requires restart)
other_pgpool_hostname1 = 'server3'
other_pgpool_port1 = 9999
other_wd_port1 = 9000


heartbeat_destination0 = 'server2'
                                    # Host name or IP address of destination 0
                                    # for sending heartbeat signal.
                                    # (change requires restart)
heartbeat_destination_port0 = 9694
                                    # Port number of destination 0 for sending
                                    # heartbeat signal. Usually this is the
                                    # same as wd_heartbeat_port.
                                    # (change requires restart)
heartbeat_device0 = ''
                                    # Name of NIC device (such like 'eth0')
                                    # used for sending/receiving heartbeat
                                    # signal to/from destination 0.
                                    # This works only when this is not empty
                                    # and pgpool has root privilege.
                                    # (change requires restart)

heartbeat_destination1 = 'server3'
heartbeat_destination_port1 = 9694
heartbeat_device1 = ''
```

- 日志(需要在/etc/rsyslog.conf 中增加 local1.\* /var/log/pgpool-II/pgpool.log )

```
log_destination = 'syslog'
                                   # Where to log
                                   # Valid values are combinations of stderr,
                                   # and syslog. Default to stderr.

syslog_facility = 'LOCAL1'
                                   # Syslog local facility. Default to LOCAL0
```

##### 脚本

都需要加执行权限

chmod +x

- /etc/pgpool-II/failover.sh (root 用户)

```bash

#!/bin/bash
# This script is run by failover_command.

set -o xtrace
exec > >(logger -i -p local1.info) 2>&1

# Special values:
#   %d = node id
#   %h = host name
#   %p = port number
#   %D = database cluster path
#   %m = new master node id
#   %H = hostname of the new master node
#   %M = old master node id
#   %P = old primary node id
#   %r = new master port number
#   %R = new master database cluster path
#   %% = '%' character

FAILED_NODE_ID="$1"
FAILED_NODE_HOST="$2"
FAILED_NODE_PORT="$3"
FAILED_NODE_PGDATA="$4"
NEW_MASTER_NODE_ID="$5"
NEW_MASTER_NODE_HOST="$6"
OLD_MASTER_NODE_ID="$7"
OLD_PRIMARY_NODE_ID="$8"
NEW_MASTER_NODE_PORT="$9"
NEW_MASTER_NODE_PGDATA="${10}"

PGHOME=/usr/pgsql-11

logger -i -p local1.info failover.sh: start: failed_node_id=${FAILED_NODE_ID} old_primary_node_id=${OLD_PRIMARY_NODE_ID} \
    failed_host=${FAILED_NODE_HOST} new_master_host=${NEW_MASTER_NODE_HOST}

## Test passwrodless SSH
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@${NEW_MASTER_NODE_HOST} -i ~/.ssh/id_rsa_pgpool ls /tmp > /dev/null

if [ $? -ne 0 ]; then
    logger -i -p local1.error failover.sh: passwrodless SSH to postgres@${NEW_MASTER_NODE_HOST} failed. Please setup passwrodless SSH.
    exit 1
fi

# If standby node is down, skip failover.
if [ ${FAILED_NODE_ID} -ne ${OLD_PRIMARY_NODE_ID} ]; then
    logger -i -p local1.info failover.sh: Standby node is down. Skipping failover.
    exit 0
fi

# Promote standby node.
logger -i -p local1.info failover.sh: Primary node is down, promote standby node PostgreSQL@${NEW_MASTER_NODE_HOST}.

ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
postgres@${NEW_MASTER_NODE_HOST} -i ~/.ssh/id_rsa_pgpool ${PGHOME}/bin/pg_ctl -D ${NEW_MASTER_NODE_PGDATA} -w promote


if [ $? -ne 0 ]; then
    logger -i -p local1.error failover.sh: new_master_host=${NEW_MASTER_NODE_HOST} promote failed
    exit 1
fi

logger -i -p local1.info failover.sh: end: new_master_node_id=$NEW_MASTER_NODE_ID started as the primary node
exit 0
```

- /etc/pgpool-II/follow_master.sh (root 用户)

```bash

#!/bin/bash
# This script is run after failover_command to synchronize the Standby with the new Primary.

set -o xtrace
exec > >(logger -i -p local1.info) 2>&1

# special values:  %d = node id
#                  %h = host name
#                  %p = port number
#                  %D = database cluster path
#                  %m = new master node id
#                  %M = old master node id
#                  %H = new master node host name
#                  %P = old primary node id
#                  %R = new master database cluster path
#                  %r = new master port number
#                  %% = '%' character
FAILED_NODE_ID="$1"
FAILED_NODE_HOST="$2"
FAILED_NODE_PORT="$3"
FAILED_NODE_PGDATA="$4"
NEW_MASTER_NODE_ID="$5"
OLD_MASTER_NODE_ID="$6"
NEW_MASTER_NODE_HOST="$7"
OLD_PRIMARY_NODE_ID="$8"
NEW_MASTER_NODE_PORT="$9"
NEW_MASTER_NODE_PGDATA="${10}"

PGHOME=/usr/pgsql-11
ARCHIVEDIR=/var/lib/pgsql/archivedir
REPL_USER=repl
REPL_PASSWORD=repl
PCP_USER=pgpool
PGPOOL_PATH=/usr/bin
PCP_PORT=9898


# Recovery the slave from the new primary
logger -i -p local1.info follow_master.sh: start: synchronize the Standby node PostgreSQL@${FAILED_NODE_HOST} with the new Primary node PostgreSQL@${NEW_MASTER_NODE_HOST}

## Test passwrodless SSH
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@${NEW_MASTER_NODE_HOST} -i ~/.ssh/id_rsa_pgpool ls /tmp > /dev/null

if [ $? -ne 0 ]; then
    logger -i -p local1.error follow_master.sh: passwrodless SSH to postgres@${NEW_MASTER_NODE_HOST} failed. Please setup passwrodless SSH.
    exit 1
fi

## Get PostgreSQL major version
PGVERSION=`${PGHOME}/bin/initdb -V | awk '{print $3}' | sed 's/\..*//' | sed 's/\([0-9]*\)[a-zA-Z].*/\1/'`

if [ ${PGVERSION} -ge 12 ]; then
    RECOVERYCONF=${FAILED_NODE_PGDATA}/myrecovery.conf
else
    RECOVERYCONF=${FAILED_NODE_PGDATA}/recovery.conf
fi

# Check the status of standby
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    postgres@${FAILED_NODE_HOST} -i ~/.ssh/id_rsa_pgpool ${PGHOME}/bin/pg_ctl -w -D ${FAILED_NODE_PGDATA} status

## If Standby is running, run pg_basebackup.
if [ $? -eq 0 ]; then

    # Execute pg_basebackup
    ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@${FAILED_NODE_HOST} -i ~/.ssh/id_rsa_pgpool "

        set -o errexit
        ${PGHOME}/bin/pg_ctl -w -m f -D ${FAILED_NODE_PGDATA} stop

        rm -rf ${FAILED_NODE_PGDATA}
        rm -rf ${ARCHIVEDIR}/*

        ${PGHOME}/bin/pg_basebackup -h ${NEW_MASTER_NODE_HOST} -U ${REPL_USER} -p ${NEW_MASTER_NODE_PORT} -D ${FAILED_NODE_PGDATA} -X stream

        if [ ${PGVERSION} -ge 12 ]; then
            sed -i -e \"\\\$ainclude_if_exists = '$(echo ${RECOVERYCONF} | sed -e 's/\//\\\//g')'\" \
                   -e \"/^include_if_exists = '$(echo ${RECOVERYCONF} | sed -e 's/\//\\\//g')'/d\" ${FAILED_NODE_PGDATA}/postgresql.conf
        fi

        cat > ${RECOVERYCONF} << EOT
primary_conninfo = 'host=${NEW_MASTER_NODE_HOST} port=${NEW_MASTER_NODE_PORT} user=${REPL_USER} password=${REPL_PASSWORD}'
recovery_target_timeline = 'latest'
restore_command = 'scp -P 32200 -i  ~/.ssh/id_rsa_pgpool ${NEW_MASTER_NODE_HOST}:${ARCHIVEDIR}/%f %p'
EOT

        if [ ${PGVERSION} -ge 12 ]; then
            touch ${FAILED_NODE_PGDATA}/standby.signal
        else
            echo \"standby_mode = 'on'\" >> ${RECOVERYCONF}
        fi
    "

    if [ $? -ne 0 ]; then
        logger -i -p local1.error follow_master.sh: end: pg_basebackup failed
        exit 1
    fi

    # start Standby node on ${FAILED_NODE_HOST}
    ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
            postgres@${FAILED_NODE_HOST} -i ~/.ssh/id_rsa_pgpool $PGHOME/bin/pg_ctl -l /dev/null -w -D ${FAILED_NODE_PGDATA} start

    # If start Standby successfully, attach this node
    if [ $? -eq 0 ]; then

        # Run pcp_attact_node to attach Standby node to Pgpool-II.
        ${PGPOOL_PATH}/pcp_attach_node -w -h localhost -U $PCP_USER -p ${PCP_PORT} -n ${FAILED_NODE_ID}

        if [ $? -ne 0 ]; then
            logger -i -p local1.error follow_master.sh: end: pcp_attach_node failed
            exit 1
        fi

    # If start Standby failed, drop replication slot "${FAILED_NODE_HOST}"
    else
        logger -i -p local1.error follow_master.sh: end: follow master command failed
        exit 1
    fi

else
    logger -i -p local1.info follow_master.sh: failed_nod_id=${FAILED_NODE_ID} is not running. skipping follow master command
    exit 0
fi

logger -i -p local1.info follow_master.sh: end: follow master command complete
exit 0
```

- /var/lib/pgsql/11/data/recovery_1st_stage (postgres 用户,主节点)

```bash

#!/bin/bash
# This script is executed by "recovery_1st_stage" to recovery a Standby node.

set -o xtrace
exec > >(logger -i -p local1.info) 2>&1

PRIMARY_NODE_PGDATA="$1"
DEST_NODE_HOST="$2"
DEST_NODE_PGDATA="$3"
PRIMARY_NODE_PORT="$4"
DEST_NODE_PORT=5432

PRIMARY_NODE_HOST=$(hostname)
PGHOME=/usr/pgsql-11
ARCHIVEDIR=/var/lib/pgsql/archivedir
REPL_USER=repl
REPL_PASSWORD=repl

logger -i -p local1.info recovery_1st_stage: start: pg_basebackup for Standby node PostgreSQL@{$DEST_NODE_HOST}

## Test passwrodless SSH
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@${DEST_NODE_HOST} -i ~/.ssh/id_rsa_pgpool ls /tmp > /dev/null

if [ $? -ne 0 ]; then
    logger -i -p local1.error recovery_1st_stage: passwrodless SSH to postgres@${DEST_NODE_HOST} failed. Please setup passwrodless SSH.
    exit 1
fi

## Get PostgreSQL major version
PGVERSION=`${PGHOME}/bin/initdb -V | awk '{print $3}' | sed 's/\..*//' | sed 's/\([0-9]*\)[a-zA-Z].*/\1/'`
if [ $PGVERSION -ge 12 ]; then
    RECOVERYCONF=${DEST_NODE_PGDATA}/myrecovery.conf
else
    RECOVERYCONF=${DEST_NODE_PGDATA}/recovery.conf
fi

## Execute pg_basebackup to recovery Standby node
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@$DEST_NODE_HOST -i ~/.ssh/id_rsa_pgpool "

    set -o errexit

    rm -rf $DEST_NODE_PGDATA
    rm -rf $ARCHIVEDIR/*

    ${PGHOME}/bin/pg_basebackup -h ${PRIMARY_NODE_HOST} -U ${REPL_USER} -p ${PRIMARY_NODE_PORT} -D ${DEST_NODE_PGDATA} -X stream

    if [ ${PGVERSION} -ge 12 ]; then
        sed -i -e \"\\\$ainclude_if_exists = '$(echo ${RECOVERYCONF} | sed -e 's/\//\\\//g')'\" \
               -e \"/^include_if_exists = '$(echo ${RECOVERYCONF} | sed -e 's/\//\\\//g')'/d\" ${DEST_NODE_PGDATA}/postgresql.conf
    fi

    cat > ${RECOVERYCONF} << EOT
primary_conninfo = 'host=${PRIMARY_NODE_HOST} port=${PRIMARY_NODE_PORT} user=${REPL_USER} password=${REPL_PASSWORD}'
recovery_target_timeline = 'latest'
restore_command = 'scp -P 32200 -i  ~/.ssh/id_rsa_pgpool ${PRIMARY_NODE_HOST}:${ARCHIVEDIR}/%f %p'
EOT

    if [ ${PGVERSION} -ge 12 ]; then
        touch ${DEST_NODE_PGDATA}/standby.signal
    else
        echo \"standby_mode = 'on'\" >> ${RECOVERYCONF}
    fi

    sed -i \"s/#*port = .*/port = ${DEST_NODE_PORT}/\" ${DEST_NODE_PGDATA}/postgresql.conf
"

if [ $? -ne 0 ]; then
    logger -i -p local1.error recovery_1st_stage: end: pg_basebackup failed. online recovery failed
    exit 1
fi

logger -i -p local1.info recovery_1st_stage: end: recovery_1st_stage complete
exit 0
```

- /var/lib/pgsql/11/data/pgpool_remote_start (postgres 用户,主节点)

```bash

#!/bin/bash
# This script is run after recovery_1st_stage to start Standby node.

set -o xtrace
exec > >(logger -i -p local1.info) 2>&1

PGHOME=/usr/pgsql-11
DEST_NODE_HOST="$1"
DEST_NODE_PGDATA="$2"


logger -i -p local1.info pgpool_remote_start: start: remote start Standby node PostgreSQL@$DEST_NODE_HOST

## Test passwrodless SSH
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@${DEST_NODE_HOST} -i ~/.ssh/id_rsa_pgpool ls /tmp > /dev/null

if [ $? -ne 0 ]; then
    logger -i -p local1.error pgpool_remote_start: passwrodless SSH to postgres@${DEST_NODE_HOST} failed. Please setup passwrodless SSH.
    exit 1
fi

## Start Standby node
ssh -p 32200 -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@$DEST_NODE_HOST -i ~/.ssh/id_rsa_pgpool "
    $PGHOME/bin/pg_ctl -l /dev/null -w -D $DEST_NODE_PGDATA start
"

if [ $? -ne 0 ]; then
    logger -i -p local1.error pgpool_remote_start: PostgreSQL@$DEST_NODE_HOST start failed.
    exit 1
fi

logger -i -p local1.info pgpool_remote_start: end: PostgreSQL@$DEST_NODE_HOST started successfully.
exit 0
```

##### 添加扩展（主节点）

```bash
[server1]# su - postgres
[server1]$ psql template1 -c "CREATE EXTENSION pgpool_recovery"
```

##### 设置客户端访问

- 设置`/etc/pgpool-II/pool_hba.conf`(不要留其它选项)

```
host    all         all           0.0.0.0/0          md5
```

##### pool_password

该文件会在执行文件后自动生成。从远程连接 pgpool 的时候，需要使用该密码来访问，pgpool 使用该用户密码来访问后面的真正的数据库。

```bash
pg_md5 -m -p -u postgres pool_passwd
```

更新

```bash
pgpool -F /etc/pgpool-II/pool_passwd reload
```

##### /etc/sysconfig/pgpool

```bash
[all servers]# vim /etc/sysconfig/pgpool
...
OPTS=" -D -n"
```

##### 日志

- 创建日志文件

```bash
[all servers]# mkdir /var/log/pgpool-II
[all servers]# touch /var/log/pgpool-II/pgpool.log
```

- 修改  /etc/rsyslog.conf.

```bash
 [all servers]# vi /etc/rsyslog.conf
...
*.info;mail.none;authpriv.none;cron.none;LOCAL1.none    /var/log/messages
LOCAL1.*                                                /var/log/pgpool-II/pgpool.log
```

- 设置转存.

```bash
[all servers]# vi /etc/logrotate.d/syslog
...
/var/log/messages
/var/log/pgpool-II/pgpool.log
/var/log/secure
```

- 重启日志服务

```bash
[all servers]# systemctl restart rsyslog
```

#####   配置 PCP 命令

```bash
[all servers]# echo 'pgpool:'`pg_md5  pgpool` >> /etc/pgpool-II/pcp.conf
```

##### 设置 .pcppass

```bash
[all servers]# echo 'localhost:9898:pgpool:pgpool' > ~/.pcppass
[all servers]# chmod 600 ~/.pcppass
```

#### 设置从节点

前提是主节点的 pgpool 及 postgresql 已经启动

- 设置 PostgreSQL standby server

```bash
# pcp_recovery_node -h 172.53.29.53 -p 9898 -U pgpool -n 1
Password:
pcp_recovery_node -- Command Successful
```

```bash
# pcp_recovery_node -h 172.53.29.53 -p 9898 -U pgpool -n 2
Password:
pcp_recovery_node -- Command Successful
```

#### 自定义用户及数据库

- 创建用户(密码:Zzb!@#123)及数据库

```sql
postgres=# create role zzb_db with login;
postgres=# \password zzb_db
postgres=# create database zzb_db owner zzb_db;
postgres=# grant all on database zzb_db to zzb_db;
```

- 添加 pool_passwd

```
pg_md5 -m -p -u zzb_db pool_passwd
```

#### 使用

##### 启动/停止 Pgpool-II

先启动 postgresql 再启用 pgpool ，先停 pgpool 再停 postgresql

- 启动  Pgpool-II

```bash
# systemctl start pgpool.service
```

- 停止  Pgpool-II

```bash
# systemctl stop pgpool.service
```

##### 常用操作

使用 pgpool 进入 postgres

- 查看数据库状态

```sql
show pool_nodes;
```

- 查看 pgpool 进程 信息

```sql
show pool_processes;
```

- 查看 pgpool 配置信息

```sql
show pool_status;
```

- 查看 pgpool 连接池

```sql
show pool_pools;
```

##### pcp 配置管理 pgpool

- 查看 pgpool 集群状态

```bash
pcp_watchdog_info -h172.53.29.53 -p 9898 -U postgres -v
```

- 查看节点数量

```bash
pcp_node_count  -h172.53.29.53 -p 9898 -U postgres -v
```

- 查看 pgpool 集群配置

```bash
pcp_pool_status -h172.53.29.53 -p 9898 -U postgres -v
```

##### 在线恢复

在要启动的节点过运行

```
# pcp_recovery_node -h {master} -p 9898 -U pgpool -n 0
```

## Go micro

### consul(v1.5.2)

#### 下载

```bash
curl  https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip -o consul_1.5.2_linux_amd64.zip
```

#### 安装

```bash
unzip consul_1.5.2_linux_amd64.zip  -d /usr/local/bin
```

#### 启动

- 节点 1

```bash
mkdir /opt/consul
nohup consul agent -server  -bootstrap-expect 1 -bind=172.53.29.53 -client=0.0.0.0 -data-dir=/opt/consul/data  -node=node1 >> /opt/consul/consul.log &
```

- 节点 2

```bash
mkdir /opt/consul
nohup consul agent -server  -bind=172.53.29.54 -client=0.0.0.0 -data-dir=/opt/consul/data  -node=node2  -join 172.53.29.53  >> /opt/consul/consul.log &
```

- 节点 3

```bash
mkdir /opt/consul
nohup consul agent -server  -bind=172.53.29.55 -client=0.0.0.0 -data-dir=/opt/consul/data -node=node3  -join 172.53.29.53  >> /opt/consul/consul.log  &
```

### Micro(master)

#### 安装

直接将 micro 的二进制执行文件放入`/usr/local/bin`目录下即可

#### 设置环境变量

```
# vim /etc/profile
```

增加

```bash
export MICRO_REGISTRY=consul
```

生效

```bash
source /etc/profile
```

#### 启动

```
mkdir /opt/micro
nohup micro --server_address=172.53.29.53:8181 api --address 0.0.0.0:8080 --handler=web >> /opt/micro/micro.log &
```

不同服务的`server_address`以`ip:port`的形式指定

### 应用安装

- 所有应用安装在 `/opt/zzb`目录下
- 所有应用日志印都输出到 `/var/log`目录
- 所有应用初次启动都会生成配置到`/etc`对应名称的目录下
- 所有应用启动时要使用 `--server_address=` 以 `ip:port`的形式指定服务地址(ip 为本机 IP,同一台机器上的端口不冲突即可)

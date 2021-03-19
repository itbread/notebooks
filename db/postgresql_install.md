#### 数据库安装

```bash
yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

yum install -y postgresql11 postgresql11-server
#初始化数据库
/usr/pgsql-11/bin/postgresql-11-setup initdb
#设置开机启动
systemctl enable postgresql-11
#启动 postgresql
systemctl start postgresql-11
#查看 postgresql
systemctl status postgresql-11
```

#### 修改指定的数据目录（可选）

```bash
#a.修改指定的数据目录
[root@work_pc ~]# vi /usr/lib/systemd/system/postgresql-11.service

# 执行前须执行命令:
#     1. mkdir -p /data/pgsql/
#     2. chown postgres:postgres -R /data/pgsql
#     3. chmod 700 /data/pgsql/data -R
#修改Environment=PGDATA=/var/lib/pgsql/11/data/为
Environment=PGDATA=/data/pgsql/data/

#b.修改数据目录
[root@work_pc ~]# vi /data/pgsql/data/postgresql.conf
#执行前须执行命令:
#     1. mkdir -p /data/pgsql/
#     2. chown postgres:postgres -R /data/pgsql
#     3. chmod 700 /data/pgsql/data -R
#修改data_directory:
 data_directory = '/data/pgsql/data'

其它配置修改:
log_directory = 'log'
max_connections = 100

```

```bash
## 重新加载配置文件，重启数据库
[root@work_pc ~]# systemctl daemon-reload
[root@work_pc ~]# systemctl restart postgresql-11
[root@work_pc ~]# ps -ef | grep postgres  #确认启动成功
```

#### 设置远程连接

```
[root@work_pc ~]# su postgres
[postgres@work_pc root]$ psql
could not change directory to "/root": Permission denied
psql (11.1)
Type "help" for help.

postgres=#

#------------------------------------------------------
#执行命令
postgres=# ALTER ROLE postgres WITH PASSWORD '123456';

```

#### 修改连接权限

```bash
#修改1， ps：认证方式解释见附录
# [postgres@work_pc root]$ vi /var/lib/pgsql/11/data/pg_hba.conf
[postgres@work_pc root]$ vi /data/pgsql/data/pg_hba.conf
# IPv4 local connections:
#host    all             all             127.0.0.1/32            ident
host    all             all             0.0.0.0/0                 md5

#new
host    all             all             0.0.0.0/0               trust

#修改2
# [root@work_pc ~]# vi /var/lib/pgsql/11/data/postgresql.conf
[root@work_pc ~]# vi /data/pgsql/data/postgresql.conf
#修改listen_addresses
listen_addresses = '*'
#有需求修改port
#port = 5432

#重启数据库
[root@work_pc ~]# systemctl restart postgresql-11
```

#### 常用数据库命令

```bash
[root@work_pc ~]# su postgres
[postgres@work_pc root]$ psql  #进入postgresql命令行

postgres=# \q   # 退出 or: exit;
postgres=# \l   # 列出所有库
postgres=# \du  # 列出所有用户, 指令显示用户和用户的用户属性
postgres=# \d   # 列出库下所有表
postgres=# \di  # 查看索引
postgres=# \dt   # 列举表, 相当于mysql的show tables
postgres=# \dn  # 查看模式schema列表
postgres=# \dn+ # 查看模式schema列表详情

postgres=# \z 或 \dp  # 显示用户访问权限
postgres=# \c dbname  # 切换数据库,相当于mysql的use dbname
postgres=# \d tblname # 查看表结构, 相当于desc tblname,show columns from tbname

postgres=# DROP DATABASE phone; # 删除数据库

# 指令查看全部可设置的管理权限
postgres=# \h CREATE ROLE

# 显示所有可设置的访问权限
postgres=# \h GRANT


# 创建表(大小写均可)
work_db=# create table test(id integer not null primary key);

# 添加表的字段
work_db=# alter table phone add column phone_number character varying(11) not null;

# 重命名一个表
work_db=# alter table [表名A] rename to [表名B];

# 删除一个表
work_db=# drop table [表名];

```

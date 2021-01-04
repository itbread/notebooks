# Ubuntu 安装 MySQL 5.7.26

# 安装 mysql

```bash
sudo apt-get install mysql-server
```

# 安装配置

```bash
sudo mysql_secure_installation

#1
VALIDATE PASSWORD PLUGIN can be used to test passwords...
Press y|Y for Yes, any other key for No: N (我的选项)

#2
Please set the password for root here...
New password: (输入密码)
Re-enter new password: (重复输入)

#3
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them...
Remove anonymous users? (Press y|Y for Yes, any other key for No) : N (我的选项)

#4
Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network...
Disallow root login remotely? (Press y|Y for Yes, any other key for No) : Y (我的选项)

#5
By default, MySQL comes with a database named 'test' that
anyone can access...
Remove test database and access to it? (Press y|Y for Yes, any other key for No) : N (我的选项)

#6
Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.
Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y (我的选项)
```

# mysql -udebian-sys-maint -p

```
Enter password:
...
mysql>
```

# 检查 mysql 服务状态

```bash
systemctl status mysql.service
```

# 修改密码

```sql
UPDATE mysql.user SET authentication_string=PASSWORD('123456'), PLUGIN='mysql_native_password' WHERE USER='root';
或者
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '12345678';
```

# 修改允许远程登录

```
vim /etc/mysql/mysql.conf.d/mysqld.cnf
找到
bind-address            = 127.0.0.1
改成
#bind-address            = 127.0.0.1
或者
bind-address            = 0.0.0.0
```

```sql
 grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;
 HEAD
 FLUSH PRIVILEGES;
```

## 定时任务

```sql
-- 查看是否开启 定时任务
 show variables like '%event_scheduler%';
--设置 开启定时任务
 SET GLOBAL event_scheduler = ON;
-- 查询定时任务
SELECT * FROM information_schema.EVENTS;
```

### 每天 21:40 删除 db_user_info 的例子

```sql
CREATE DEFINER=`root`@`localhost` EVENT `del_event`
ON SCHEDULE EVERY 1 DAY STARTS '2020-12-10 21:40:00'
ON COMPLETION PRESERVE ENABLE DO delete  FROM db_user_info
```

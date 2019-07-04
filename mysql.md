# Ubuntu 安装MySQL 5.7.26

#  安装mysql
``` bash
sudo apt-get install mysql-server
```

# 安装配置
``` bash
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

#    检查mysql服务状态
``` bash
systemctl status mysql.service
```

# 修改密码
``` sql
UPDATE mysql.user SET authentication_string=PASSWORD('123456'), PLUGIN='mysql_native_password' WHERE USER='root';
```

#   修改允许远程登录
```
vim /etc/mysql/mysql.conf.d/mysqld.cnf
找到
bind-address            = 127.0.0.1
改成
#bind-address            = 127.0.0.1
或者
bind-address            = 0.0.0.0
```
``` sql
 grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;
 FLUSH PRIVILEGES; 
```
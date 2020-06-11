#   安装influxdb
```
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.7.6_amd64.deb
sudo dpkg -i influxdb_1.7.6_amd64.deb
sudo service influxdb start
influx  //连接 influxdb
create database vehicle_db //创建数据库
show databases             // 查看数据库

```



# http api 操作
## 创建 database
``` bash
curl -XPOST 'http://localhost:8086/query?u=myusername&p=mypassword' --data-urlencode 'q=CREATE DATABASE "mydb"'
```
## 写数据 
``` bash
curl -i -XPOST "http://localhost:8086/write?db=mydb&precision=s" --data-binary 'mymeas,mytag=1 myfield=90 1463683075'

```
## 带验证的写数据 
``` bash
curl -i -XPOST "http://localhost:8086/write?db=mydb&u=myusername&p=mypassword" --data-binary 'mymeas,mytag=1 myfield=91'
```

## 查询 
``` bash
 curl -G 'http://localhost:8086/query?db=mydb&epoch=s' --data-urlencode 'q=SELECT * FROM "mymeas"'
```

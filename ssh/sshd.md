# linux shell ssh 连接一段时间后假死

## 解决办法

```bash
### 客户端
vim /etc/ssh/ssh_config

### 添加：
ServerAliveInterval 50
ServerAliveCountMax 3

### 服务端
vim /etc/ssh/sshd_config

### 添加：
ClientAliveInterval 50 #每隔50秒就向服务器发送一个请求
ClientAliveCountMax 3 #允许超时的次数，一般都会响应

### 重启ssh服务器

service sshd restart
或者
systemctl restart sshd
```

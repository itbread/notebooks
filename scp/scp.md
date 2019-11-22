#scp 使用教程

## 拷贝单个文件

```bash
scp file1 ycg@192.168.0.68:/home/ycg/
```

## 拷贝多个文件

```bash
scp root@192.168.0.101:/opt/zzb/"{*_service,*_portal,thirdparty}"   /home/ycg/
```

## 拷贝目录

```bash
scp -r root@192.168.0.101:/opt/zzb/   /home/ycg/
```

## SecureCRT xshell 下的文件传输协议有以下几种：ASCII、Xmodem、Ymodem、Zmodem

### 系统上需要安装 lrzsz

```bash
centos
yum -y install lrzsz

ubuntu
apt-get install lrzsz
```

#  zzb 小程序 环境搭建

#  consul 服务
## 下载
```bash
curl  https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_amd64.zip -o consul_1.4.4_linux_amd64.zip
```
## 安装
```bash
unzip consul_1.4.4_linux_amd64.zip  -d /usr/local/bin
```

## 启动consul
```
注意 -bind=你的ip
consul agent -server  -bootstrap-expect 1 -bind=192.168.0.11 -client=0.0.0.0 -data-dir=data -node=node1
```

### 方式一 micro 新版本默认 mdns（测试版本为 v1.1.1）
``` bash
 micro api --handler=web
 micro web
 go run main.go  //如 user_service

```


### 方式二 micro 指定 consul
```
  MICRO_REGISTRY=consul micro api --handler=web
  MICRO_REGISTRY=consul micro web
  go run main.go --registry=consul //如 user_service
 
```

# 获取 zzb 工程代码
```  bash
go get --insecure git.kaifakuai.com/zzb/redis_session
go get --insecure git.kaifakuai.com/zzb/docs
go get --insecure git.kaifakuai.com/zzb/stu_mp_portal
go get --insecure git.kaifakuai.com/zzb/trade_service
go get --insecure git.kaifakuai.com/zzb/notify_service
go get --insecure git.kaifakuai.com/zzb/ads_service
go get --insecure git.kaifakuai.com/zzb/file_server
go get --insecure git.kaifakuai.com/zzb/user_service

```
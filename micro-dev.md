# 开发环境搭建

# 下载代码  
``` bash
 go get --insecure git.kaifakuai.com/driving_school/auth_service  
 go get --insecure git.kaifakuai.com/driving_school/device_api  
 go get --insecure git.kaifakuai.com/driving_school/dsm_portal  
 go get --insecure git.kaifakuai.com/driving_school/file_server  
 go get --insecure git.kaifakuai.com/driving_school/goseaweedfs  
 go get --insecure git.kaifakuai.com/driving_school/user_api  
 go get --insecure git.kaifakuai.com/driving_school/docs
```
# 安装go-micro框架  
``` bash
go get github.com/micro/go-micro
```

# 安装 protobuf 
``` 
  go get -u -v github.com/golang/protobuf/{proto,protoc-gen-go}  
  go get -u -v github.com/micro/protoc-gen-micro
```

# 修改配置  (注意：服务都需要在本机运行)
因相关服务没有正式部署，本地运行服务提供测试环境。
默认情况下下面配置文件不要修改，192.168.0.126是 192.168.0.101 上的虚拟服务器。

auth_service configs/config.json配置
```
{
  "log": {
    "path": "log",
    "filename": "auth_service.log",
    "level": "debug",
    "maxAge": 8640000,
    "rotateTime": 86400,
    "elastic_url": "http://192.168.0.126:19200",
    "elastic_index": "auth_service_log",
    "host": "localhost"
  }
}
```

user_api configs/config.json 配置
```
{
  "log": {
    "path": "log",
    "filename": "user_api.log",
    "level": "debug",
    "maxAge": 8640000,
    "rotateTime": 86400,
    "elastic_url": "http://192.168.0.126:19200",
    "elastic_index": "user_api_log",
    "host": "localhost"
  }
}
```

```
dsm_portal 中 user_service 写死了一个地址，需要改成 你自己的ip
```

#  consul 服务
## 下载
```bash
curl  https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_amd64.zip -o consul_1.4.4_linux_amd64.zip
```
## 安装
```bash
unzip consul_1.4.4_linux_amd64.zip  -d /usr/local/bin
```
## 启动
```
注意 -bind=你的ip
consul agent -server  -bootstrap-expect 1 -bind=192.168.0.11 -client=0.0.0.0 -data-dir=data -node=node1
```




### 方式一 micro 新版本默认 mdns（测试版本为 v1.1.1）
``` bash
 micro api --handler=web
 micro web
 go run main.go  //user_api
 go run main.go  //device_api
 go run main.go  //auth_service
```


### 方式二 micro 指定 consul
```
  MICRO_REGISTRY=consul micro api --handler=web
  MICRO_REGISTRY=consul micro web
  go run main.go --registry=consul //user_api
  go run main.go --registry=consul //device_api
  go run main.go --registry=consul //auth_service
```

或者 在系统环境变量(/etc/profile  或者  ~/.bashrc )最后位置添加，注意： /etc/profile 中修改，需要重启电脑生效
``` bash
export MICRO_REGISTRY=consul
```

上面运行参数可以简化如下：
```
  micro api --handler=web
  micro web
  go run main.go  //user_api
  go run main.go  //device_api
  go run main.go  //auth_service
```







# 开发环境搭建

go get github.com/go-chi/chi  
go get github.com/rs/cors  
go get github.com/go-chi/render  

# 下载代码  
+ go get --insecure git.kaifakuai.com/driving_school/auth_service  
+ go get --insecure git.kaifakuai.com/driving_school/device_api  
+ go get --insecure git.kaifakuai.com/driving_school/dsm_portal  
+ go get --insecure git.kaifakuai.com/driving_school/file_server  
+ go get --insecure git.kaifakuai.com/driving_school/goseaweedfs  
+ go get --insecure git.kaifakuai.com/driving_school/user_api  
+ go get --insecure git.kaifakuai.com/driving_school/docs

# 安装go-micro框架  
go get github.com/micro/go-micro

# 安装 protobuf  
+ go get -u -v github.com/golang/protobuf/{proto,protoc-gen-go}  
+ go get -u -v github.com/micro/protoc-gen-micro

# 修改配置  (注意：服务都需要在本机运行)
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
+ micro api --handler=web
+ micro web
+ go run main.go  //user_api
+ go run main.go  //auth_service


### 方式二 micro 指定 consul
+  MICRO_REGISTRY=consul micro api --handler=web
+  go run main.go --registry=consul //user_api
+  go run main.go --registry=consul //auth_service
+  MICRO_REGISTRY=consul micro web







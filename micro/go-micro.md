在gopath 下src目录下创建文件夹golang.org，拉取相关包

mkdir golang.org

cd golang.org

mkdir x

cd x

git clone https://github.com/golang/net.git

git clone https://github.com/golang/crypto.git

git clone https://github.com/golang/sys.git

git clone https://github.com/golang/text.git

git clone https://github.com/golang/tools.git

 
在gopath 下src目录下创建文件夹google.golang.org
mkdir google.golang.org

cd google.golang.org

git clone https://github.com/grpc/grpc-go.git grpc

git clone https://github.com/google/go-genproto.git genproto
 

go get -u github.com/golang/protobuf/protoc-gen-go
go get github.com/micro/protoc-gen-micro

 
go get -v github.com/micro/micro

go get -v github.com/micro/go-micro

go get -v github.com/micro/go-plugins

 

设置代理（go1.12.5）

export GOPROXY="https://goproxy.io"

 

进入项目

go mod init ***

vim go.mod

require (
        github.com/99designs/gqlgen v0.7.1
        github.com/emicklei/go-restful v2.8.1+incompatible
        github.com/gin-contrib/sse v0.0.0-20190125020943-a7658810eb74 // indirect
        github.com/gin-gonic/gin v1.3.0
        github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b
        github.com/golang/protobuf v1.3.1
        github.com/gorilla/websocket v1.4.0
        github.com/grpc-ecosystem/grpc-gateway v1.7.0
        github.com/hailocab/go-geoindex v0.0.0-20160127134810-64631bfe9711
        github.com/hashicorp/go-rootcerts v1.0.0
        github.com/micro/cli v0.2.0
        github.com/micro/go-api v0.5.0
        github.com/micro/go-bot v0.1.0
        github.com/micro/go-config v0.13.3
        github.com/micro/go-grpc v0.9.0
        github.com/micro/go-log v0.1.0
        github.com/micro/go-micro v1.5.0
        github.com/micro/go-plugins v0.22.0
        github.com/micro/go-web v0.6.0
        github.com/micro/micro v0.22.0
        github.com/nu7hatch/gouuid v0.0.0-20131221200532-179d4d0c4d8d
        github.com/pborman/uuid v1.2.0
        github.com/vektah/gqlparser v1.1.0
        golang.org/x/net v0.0.0-20190603091049-60506f45cf65
        google.golang.org/genproto v0.0.0-20190530194941-fb225487d101
        google.golang.org/grpc v1.21.1
        gopkg.in/go-playground/validator.v8 v8.18.2 // indirect
)

 

go build/run 

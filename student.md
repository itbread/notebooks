
#启动 consul
consul agent -server  -bootstrap-expect 1 -bind=192.168.0.11 -client=0.0.0.0 -data-dir=data -node=node3 -join 192.168.0.101
consul agent -server  -bind=192.168.0.11 -client=0.0.0.0 -data-dir=data -node=node3 -join 192.168.0.101

运行cosnul agent以server模式，

-server ： 定义agent运行在server模式
-bootstrap-expect ：在一个datacenter中期望提供的server节点数目，当该值提供的时候，consul一直等到达到指定sever数目的时候才会引导整个集群，该标记不能和bootstrap共用
-bind：该地址用来在集群内部的通讯，集群内的所有节点到地址都必须是可达的，默认是0.0.0.0
-node：节点在集群中的名称，在一个集群中必须是唯一的，默认是该节点的主机名
-ui-dir： 提供存放web ui资源的路径，该目录必须是可读的
-rejoin：使consul忽略先前的离开，在再次启动后仍旧尝试加入集群中。
-config-dir：配置文件目录，里面所有以.json结尾的文件都会被加载
-client：consul服务侦听地址，这个地址提供HTTP、DNS、RPC等服务，默认是127.0.0.1所以不对外提供服务，如果你要对外提供服务改成0.0.0.0

## student接口

### 授权
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/weixin/auth -d '{"openid":"wx22245"}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"id":5,"openid":"wx12345"}}
```
### 注册
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/register -d '{"openid":"wx22345","phone":"18670786695"}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"uid":12}}
```



### 登录
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/login -d '{"openid":"wx22245","phone":"18670786695"}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"uid":12}}
```

### 退出登录
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/logout -d '{"phone":"18670786695","uid":12}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success"}

```

### 获取用户信息
```
curl  http://192.168.0.101:8080/user/card/11

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"uid":11,"openid":"orF844zjz_bIcXmL8HGKvYrWGR6s","user_type":0,"phone":"18620919841","create_dt":1563175923,"update_dt":0,"name":"谢兆为","apply_code":"","gender":"男","nation":"汉","card_type":0,"card_no":"430321198808145419","issuing_authority":"湘潭县公安局","issuing_dt":1458748800,"address":"湖南省湘潭县花石镇盐埠村中安村民组","birthday":0,"expire_dt":2089900800,"contract_addr":"","emergency_contact":"","emergency_phone":"","serial_number":"","photo":"","idcard_front":"1,47c8468a0003","idcard_back":"80,47c98fc1ede8","vehicle_id":"","vehicle_pwd":"","login_dt":0,"exit_dt":1563443430}}
```


## 约试驾 

### 创建
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/drive/create -d '{"place_id": "p001",	"phone": "13688971250", "code": "1368",	"present_time": "2019-06-16 09:30~12:30"}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"drive_id":5}}
```

### 查询
```
curl http://192.168.0.101:8080/user/drive/5

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"drive_id":5,"place_id":"p001","phone":"13688971250","present_time":"2019-06-16 09:30~12:30","remark":"","status":1}}
```
### 删除
```
curl -XDELETE  http://192.168.0.101:8080/user/drive/5

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success"}
```

## 学员驾校信息

### 创建
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student_school/create -d '{"uid": 5,	"school_id": "s001"}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success"}
```
### 更新
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student_school/update -d '{"uid": 5,	"school_id": "s002"}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success"}
```

### 查询
```
curl http://192.168.0.101:8080/user/student_school/5

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"uid":5,"school_id":"s002","create_dt":1563799757,"status":1}}

```

### 根据驾校编号查询
```
curl http://192.168.0.101:8080/user/student_school/school/s001

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":[{"uid":12,"school_id":"s001","create_dt":1563852235,"status":1}]}

```

### 删除
```
curl -XDELETE  http://192.168.0.101:8080/user/student_school/5

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success"}

```


## 学员状态信息

### 查询 
```
curl http://192.168.0.101:8080/user/status/5 

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"uid":5,"order":0,"base_info":0,"pay":0,"sign":0,"submit":0,"photo":0,"high_meter":0,"item1":0,"item2":0,"item3":0,"item4":0,"pwd":0}}
```
### 更新（uid 为必填，其他为 可选，但需要填写一个）
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/status/update -d '{"uid":5,"order":0,"base_info":0,"pay":0,"sign":0,"submit":0,"photo":0,"high_meter":0,"item1":0,"item2":0,"item3":0,"item4":0,"pwd":0}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success"}

```

api 
http://api.ngrok.kaifakuai.net
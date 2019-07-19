
#启动 consul
consul agent -server  -bootstrap-expect 1 -bind=192.168.0.11 -client=0.0.0.0 -data-dir=data -node=node3 -join 192.168.0.101


# student接口

## 授权
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/weixin/auth -d '{"openid":"wx123"}'

curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/weixin/auth -d '{"openid":"wx1234"}'

## 注册
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/register -d '{"openid":"wx1234","phone":"18670786699"}'

curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/register -d '{"openid":"wx123","phone":"18670786695"}'
```
```
curl 
智悦班
智尊班

## 登录
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/login -d '{"openid":"wx123","phone":"18670786695"}'
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/login -d '{"openid":"wx1234","phone":"18670786699"}'
```

## 退出登录
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/student/logout -d '{"phone":"18670786695","uid":5}'
```

## 获取用户信息
```
curl  http://192.168.0.101:8080/user/student/get_student_detail?phone=18670786695
```



## 获取region 信息
### 根据市编号 获取其下的region信息 （层级显示）
```
curl  http://192.168.0.101:8080/user/region/get_regions?city=440100

curl  http://192.168.0.101:8080/user/region/get_regions?city=440100
```

### 根据市编号 获取region信息
```
curl  http://192.168.0.11:8080/school/region/get_region_by_id?id=440100
curl  http://192.168.0.101:8080/school/region/get_region_by_id?id=440100
```


## 创建约试练 

```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/drive/createdrive -d '{"place_id": "p001",	"phone": "13688971250", "code": "1368",	"present_time": "2019-06-16 09:30~12:30"}'
```

'{"place_id": "p001",	"phone": "13688971250", "code": "1368",	"present_time": "2019-06-16 09:30~12:30"}'


## 获取place 信息
### 根据市编号 获取场地list （层级显示）
```
curl  http://192.168.0.101:8080/school/place/places_level_city?city=440100
curl  http://192.168.0.101:8080/school/place/places_level_zone?zone=440100
curl  http://192.168.0.101:8080/school/place/places_levels

```


```
curl  http://192.168.0.101:8080/school/school/places_level_city?city=440100
curl  http://192.168.0.101:8080/school/school/places_level_zone?zone=440100
curl  http://192.168.0.101:8080/school/school/places_levels

```

curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/school/create_place -d '{"place_id": "p001",	"school_id": "s001", "place_name": "嘉禾望岗"	}'


curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/school/create_school -d '{"school_id": "p001",	"province": "s001", "school_name": "嘉禾望岗驾校"	}'

### 根据驾校编号获取场地list
```
curl  http://192.168.0.101:8080/user/school/places?school_id=s001
```


curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/user/drive/create -d '{"place_id": "p001",	"phone": "18670786695", "present_time": "2019-06-16 09:30~12:30"	}'


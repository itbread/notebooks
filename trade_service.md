# 商品属性

```
//创建属性
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/attribute/create -d '{"attribute_id": "p002",    "attribute_name": "p001",   "remark": "嘉禾望岗驾校2"	}'

//更新
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/attribute/update -d '{"attribute_id": "p002",    "attribute_name": "商品xx",   "remark": "嘉禾望岗驾校2"	}'

//查询
curl http://192.168.0.101:8080/trade/attribute/p002

//查询list
curl http://192.168.0.101:8080/trade/attribute/list

//删除
curl  -XDELETE  http://192.168.0.101:8080/trade/attribute/p002

```

# 班级
```
//创建 班级
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/class/create -d '{"goods_id":"g001","school_id":"s001","rebate":0,"amount":5000,"start_time":1563247015,"end_time":1563547015,"status":0,"remark":"商品1"}'

//更新 班级
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/class/update -d '{"goods_id":"g001","school_id":"s001","rebate":70,"amount":4500,"start_time":1563247715,"end_time":1563547815,"status":0,"remark":"商品g001"}'

//根据驾校编号查询班级
http://192.168.0.101:8080/trade/class/school/s001

//根据驾校编号与商品编号删除班级
curl  -XDELETE http://192.168.0.101:8080/trade/class/s001/g001

//根据驾校编号与商品编号查询班级
curl http://192.168.0.101:8080/trade/class/s002/g002
```


# 班型
```
//创建班型
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/type/create -d '{"class_type_id":"t001","class_type_name":"智尊班","class_type_desc":"智尊班优惠大酬宾","class_type_pic":"http://xx/xx.jpg","class_service":"http://xx/service.jpg"}'

//更新班型
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/type/update -d '{"class_type_id":"t001","class_type_name":"智尊班","class_type_desc":"智尊班优惠大酬宾","class_type_pic":"http://xx/xx.jpg","class_service":"http://xx/service.jpg"}'

//查询班型列表
curl http://192.168.0.101:8080/trade/type/list/t001

//查询所有班型列表（含商品信息）
curl http://192.168.0.101:8080/trade/type/data/list/all

//查询班型
curl http://192.168.0.101:8080/trade/type/t001

//查询班型（含商品信息）
curl http://192.168.0.101:8080/trade/type//data/t001

//删除班型
curl -XDELETE  http://192.168.0.101:8080/trade/type/t001
```
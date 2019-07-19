# 使用说明

```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/attribute/create -d '{"attribute_id": "p002",    "attribute_name": "p001",   "remark": "嘉禾望岗驾校2"	}'
//更新
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/attribute/update -d '{"attribute_id": "p002",    "attribute_name": "商品xx",   "remark": "嘉禾望岗驾校2"	}'

http://192.168.0.101:8080/trade/attribute/p002

curl  -XDELETE  http://192.168.0.101:8080/trade/attribute/p002
curl   http://192.168.0.101:8080/trade/attribute/p002

```


```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/trade/class/create -d '{"goods_id": "g001",    "school_id": "s001", "amount": 5000,"remark": "商品1"	}'

http://192.168.0.101:8080/trade/class/p002

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

//根据班型编号查询
curl http://192.168.0.101:8080/trade/types/t001
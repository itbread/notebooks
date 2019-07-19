
# student 接口

```
curl -XPOST -H"content-type:application/json" http://192.168.0.11:8080/user/student/loginout -d '{"opendi":"wx123"}'

```

```
{
    "code": 0,
    "msg": "Success",
    "sub_code": 103,
    "sub_msg": "failed to loginout",
    "data": null
}
```


curl -v -X DELETE http://192.168.0.101:8080/user/drive/1

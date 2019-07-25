
#启动 consul
consul agent -server  -bootstrap-expect 1 -bind=192.168.0.11 -client=0.0.0.0 -data-dir=data -node=node3 -join 192.168.0.101


## 获取region 信息
### 根据市编号 获取其下的region信息 （层级显示）
```
//编号
curl  http://192.168.0.101:8080/school/region/440100

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"","data":{"id":"440100","name":"广州市","parent_id":"440000","short_name":"广州","level_type":2,"city_code":"020","zip_code":"510032","longitude":113.280637,"latitude":23.125178,"pinyin":"Guangzhou"}}
```
```
//市编号--区
curl  http://192.168.0.101:8080/school/region/city/440100

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"city":"440100","name":"广州市","data":[{"id":"440103","name":"荔湾区","parent_id":"440100","short_name":"荔湾","level_type":3,"city_code":"020","zip_code":"510170","longitude":113.2442,"latitude":23.12592,"pinyin":"Liwan"},{"id":"440104","name":"越秀区","parent_id":"440100","short_name":"越秀","level_type":3,"city_code":"020","zip_code":"510030","longitude":113.26683,"latitude":23.12897,"pinyin":"Yuexiu"},{"id":"440105","name":"海珠区","parent_id":"440100","short_name":"海珠","level_type":3,"city_code":"020","zip_code":"510300","longitude":113.26197,"latitude":23.10379,"pinyin":"Haizhu"},{"id":"440106","name":"天河区","parent_id":"440100","short_name":"天河","level_type":3,"city_code":"020","zip_code":"510665","longitude":113.36112,"latitude":23.12467,"pinyin":"Tianhe"},{"id":"440111","name":"白云区","parent_id":"440100","short_name":"白云","level_type":3,"city_code":"020","zip_code":"510405","longitude":113.27307,"latitude":23.15787,"pinyin":"Baiyun"},{"id":"440112","name":"黄埔区","parent_id":"440100","short_name":"黄埔","level_type":3,"city_code":"020","zip_code":"510700","longitude":113.45895,"latitude":23.10642,"pinyin":"Huangpu"},{"id":"440113","name":"番禺区","parent_id":"440100","short_name":"番禺","level_type":3,"city_code":"020","zip_code":"511400","longitude":113.38397,"latitude":22.93599,"pinyin":"Panyu"},{"id":"440114","name":"花都区","parent_id":"440100","short_name":"花都","level_type":3,"city_code":"020","zip_code":"510800","longitude":113.22033,"latitude":23.40358,"pinyin":"Huadu"},{"id":"440115","name":"南沙区","parent_id":"440100","short_name":"南沙","level_type":3,"city_code":"020","zip_code":"511458","longitude":113.60845,"latitude":22.77144,"pinyin":"Nansha"},{"id":"440117","name":"从化区","parent_id":"440100","short_name":"从化","level_type":3,"city_code":"020","zip_code":"510900","longitude":113.587386,"latitude":23.545283,"pinyin":"Conghua"},{"id":"440118","name":"增城区","parent_id":"440100","short_name":"增城","level_type":3,"city_code":"020","zip_code":"511300","longitude":113.829579,"latitude":23.290497,"pinyin":"Zengcheng"}]}}
```

## 获取place 信息

### 查询 Places
```
//单个场地
curl  http://192.168.0.101:8080/school/place/p001

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}}

//市--区--场地
curl  http://192.168.0.101:8080/school/place/city

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":[{"id":"440100","name":"广州市","zones":[{"id":"440106","name":"天河区","places":[{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p003","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p004","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}]}]}]}

//市--区--场地
curl  http://192.168.0.101:8080/school/place/city/440100

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"id":"440100","name":"广州市","zones":[{"id":"440106","name":"天河区","places":[{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p003","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p004","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}]}]}}

//区--场地
curl  http://192.168.0.101:8080/school/place/zone/440106

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"id":"440106","name":"天河区","places":[{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p003","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p004","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}]}}

//省--市--区--场地
curl  http://192.168.0.101:8080/school/place/levels

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":[{"id":"440000","name":"广东省","citys":[{"id":"440100","name":"广州市","zones":[{"id":"440106","name":"天河区","places":[{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p003","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p004","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}]}]}]}]}


//单个省--市--区--场地
curl  http://192.168.0.101:8080/school/place/province/440000

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"id":"440000","name":"广东省","citys":[{"id":"440100","name":"广州市","zones":[{"id":"440106","name":"天河区","places":[{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p003","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p004","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}]}]}]}}

```
### 创建Places
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/school/place/create -d '{"place_id": "p002",    "school_id": "s001",	"province": "440000","city": "440100","zone": "440106", "place_name": "嘉禾望岗场地2"	}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地2","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}}
```

### 根据驾校编号获取旗下的场地
```
curl  http://192.168.0.101:8080/school/place/school/s001

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":[{"place_id":"p001","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p003","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p004","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地3","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""},{"place_id":"p002","school_id":"s001","pic_id":"","longitude":0,"latitude":0,"place_name":"嘉禾望岗场地2","manager":"","phone":"","brief":"","area":0,"contains_vehicles":0,"open_time":"","remark":""}]}
```


## 获取 school 信息

### 查询 school
```
curl  http://192.168.0.101:8080/school/school/s001

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"school_id":"s001","province":"440000","city":"440100","zone":"440106","longitude":0,"latitude":0,"school_name":"嘉禾望岗驾校","tax_id":"001","license_id":"","manager":"张三","moblie":"13688971250","fix_phone":"020-6129182","addres":"广州","remark":""}}

//市--区--场地
curl  http://192.168.0.101:8080/school/school/city/440100

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"id":"440100","name":"广州市","zones":[{"id":"440106","name":"天河区","places":[{"school_id":"s001","province":"440000","city":"440100","zone":"440106","longitude":0,"latitude":0,"school_name":"嘉禾望岗驾校","tax_id":"001","license_id":"","manager":"张三","moblie":"13688971250","fix_phone":"020-6129182","addres":"广州","remark":""}]}]}}

//区--场地
curl  http://192.168.0.101:8080/school/school/zone/440106

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"id":"440106","name":"天河区","places":[{"school_id":"s001","province":"440000","city":"440100","zone":"440106","longitude":0,"latitude":0,"school_name":"嘉禾望岗驾校","tax_id":"001","license_id":"","manager":"张三","moblie":"13688971250","fix_phone":"020-6129182","addres":"广州","remark":""}]}}

//省--市--区--场地
curl  http://192.168.0.101:8080/school/school/levels

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":[{"id":"440000","name":"广东省","citys":[{"id":"440100","name":"广州市","zones":[{"id":"440106","name":"天河区","places":[{"school_id":"s001","province":"440000","city":"440100","zone":"440106","longitude":0,"latitude":0,"school_name":"嘉禾望岗驾校","tax_id":"001","license_id":"","manager":"张三","moblie":"13688971250","fix_phone":"020-6129182","addres":"广州","remark":""}]}]}]}]}

```
### 创建 school
```
curl -XPOST -H"content-type:application/json" http://192.168.0.101:8080/school/school/create -d '{"province":"440000","city":"440100","zone":"440106","longitude":0,"latitude":0,"school_name":"悦学车(广州)智能驾驶科技有限公司","tax_id":"001","license_id":"","manager":"张三","moblie":"13688971250","fix_phone":"020-6129182","addres":"广州","remark":""}'

{"code":0,"msg":"Success","sub_code":0,"sub_msg":"Success","data":{"school_id":"s003","province":"440000","city":"440100","zone":"440106","longitude":0,"latitude":0,"school_name":"嘉禾望岗驾校3","tax_id":"001","license_id":"","manager":"张三","moblie":"13688971250","fix_phone":"020-6129182","addres":"","remark":""}}
```



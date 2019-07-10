#  curl 使用教程

## curl   get

```
curl  http://192.168.0.138:8080/user/product/EyRvarCHT_SjSzFkUznbGQ

``` 

## curl   post 

```
curl -XPOST -H"content-type:application/json" http://192.168.0.138:8080/user/product/create -d '{"name":"test_product","user_id":"5ebcf47e-d9f0-4f0f-81d3-f467105a4611"}'

``` 

## curl  delete 

```
curl  -DELETE http://192.168.0.138:8080/user/42391e6f-1ce9-49c0-8f2b-77edbe25e679

``` 




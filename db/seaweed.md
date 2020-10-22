### 文件服务器启动配置

#### 文件服务器一个 datacenter 需要 2 个 rack，否则会有问题

```bash
#!/bin/bash
echo "run master"
nohup weed master   -mdir="/opt/seaweedfs/master2" -ip="127.0.0.1" -ip.bind="127.0.0.1" -port=9333 -peers="127.0.0.1:9333"  -defaultReplication="110" >>/dev/null  &

echo "run volumes 3 and 4"
nohup weed volume -dataCenter="m5dc1"  -rack="m5rack1"  -ip="127.0.0.1" -ip.bind="127.0.0.1" -max="10" -dir="/opt/seaweedfs/volume1"  -mserver="127.0.0.1:9333" -port=8081 >>/dev/null &

nohup weed volume -dataCenter="m5dc1"  -rack="m5rack2"  -ip="127.0.0.1" -ip.bind="127.0.0.1" -max="10" -dir="/opt/seaweedfs/volume2"  -mserver="127.0.0.1:9333" -port=8082 >>/dev/null &

nohup weed volume -dataCenter="m5dc2"  -rack="m5rack1"  -ip="127.0.0.1" -ip.bind="127.0.0.1" -max="10" -dir="/opt/seaweedfs/volume3"  -mserver="127.0.0.1:9333" -port=8087 >>/dev/null   &

nohup weed volume -dataCenter="m5dc2"  -rack="m5rack2"  -ip="127.0.0.1" -ip.bind="127.0.0.1" -max="10" -dir="/opt/seaweedfs/volume4"  -mserver="127.0.0.1:9333" -port=8084 >>/dev/null  &
```

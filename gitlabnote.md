

#   github  gitlab  pull push 免密码登录 处理办法
+  vi  ～/.git-credentials
+  输入：https://{username}：{password}@github.com
+ 保存退出后执行:git config --global credential.helper store


#   go get gitlab  库资源出现以下错误解决办法

```
git clone https://git.kaifakuai.com/driving_school/auth_service.git /home/ycg/go/src/git.kaifakuai.com/driving_school/auth_service
Cloning into '/home/ycg/go/src/git.kaifakuai.com/driving_school/auth_service'...
fatal: could not read Username for 'https://git.kaifakuai.com': terminal prompts disabled
package git.kaifakuai.com/driving_school/auth_service: exit status 128
```

1. + 在环境变量中设置 export GIT_SSL_NO_VERIFY=1
2. + 在～/.git-credentials 中加入一行  https://{username}:{password}@git.kaifakuai.com



# GIT 使用教程

## 打标签

```
git tag -a v1.4 -m 'my version 1.4'

```

### 拉取 tag 信息

```
git fetch --tags
```

### 列显已有的标签

```
git tag
```

### 查看相应标签的版本信息，并连同显示打标签时的提交对象

```
git show tag
```

### 把本地 tag 推送到远程

```
git push --tags
```

### 获取远程 tag

```

git fetch origin tag <tagname>
```

### git 重新指定 服务器地址

```
git remote set-url origin git.kaifakuai.com

验证是否替换成功进入项目下的.git目录，找到config文件，打开查看url是否更改.
```

# GIT 使用教程

## 打标签

```
git tag -a v1.4 -m 'my version 1.4'

```

### 拉取 tag 信息

```
git fetch --tags
```

### 查询本地 tag 信息

```
git tag
```

### 查询本地 指定 tag 信息

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

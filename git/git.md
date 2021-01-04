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

### git 免密码登录

```

```

### 一、开发分支（dev）上的代码达到上线的标准后，要合并到 master 分支

```bash
git checkout dev
git pull
git checkout master
git merge dev
git push -u origin master
```

### 二、当 master 代码改动了，需要更新开发分支（dev）上的代码

```bash
git checkout master
git pull
git checkout dev
git merge master
git push -u origin dev
```

#### 删除分支

```bash

    切换到要操作的项目文件夹
    命令行 : $ cd <ProjectPath>   例如，$ cd /Downloads/G25_platform_sdk

    查看项目的分支们(包括本地和远程)
    命令行 : $ git branch -a     例如，$ git branch -a

    删除本地分支
    命令行 : $ git branch -d <BranchName>

    删除本地分支命令行:
    git branch -d <BranchName>

    强制删除本地分支命令行:
    git branch -D <BranchName>

    删除远程分支命令行:
    git push origin --delete <BranchName>

    举例
    我现在在 dev1 分支上，想删除 dev1 分支
　　1 先切换到别的分支: git checkout dev
　　2 删除本地分支： git branch -d dev1
　　3 如果删除不了可以强制删除，git branch -D dev1
　　4 删除远程分支(慎用)：git push origin --delete dev1

```

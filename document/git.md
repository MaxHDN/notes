# GIT使用教程

# 一、将已有的本地项目上传到github上

## 1、git init 本地仓库初始化

* 进入本地仓库的文件夹
* 右键打开Git Bash Here
* 执行git init命令

![image-20200601011019045](..\img-folder\image-20200601011019045.png)

## 2、将项目文件推送到远程github仓库

* 通过git status 查看有哪些文件或文件夹的状态
* 将需要版本管理的文件和文件夹添加到版本管理

![image-20200601011053772](..\img-folder\image-20200601011053772.png)

* 本地提交 git commit -m "first commit"

![image-20200601011122134](..\img-folder\image-20200601011122134.png)

* 在github创建远程仓库

![image-20200601010654622](..\img-folder\image-20200601010654622.png)

* 绑定远程仓库

  git remote add origin https://github.com/MaxHDN/IPersistence_Test.git

![image-20200601010910820](..\img-folder\image-20200601010910820.png)

* 绑定之后把本地仓库内容推送到远程仓库

git push -u origin master    第一次推送内容要加入 -u 这个参数

由于本地已经设置好了远程仓库的账户密码，如果没设置，还需要设置账户密码

![image-20200601011530807](..\img-folder\image-20200601011530807.png)

* 之后就可以正常操作git了
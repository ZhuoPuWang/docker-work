# jwschain-docker

#### 介绍
```
docker服务端布署环境
```

#### 软件架构
```
docker架构
```

#### 安装教程
```
一 . 下载docker
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose

#将用户添加到docker组里面
usermod -aG docker {用户名}

#启动docker, 如果出现问题, 退出当前终端后再次登录进去
sudo systemctl start docker


二 . 拉取代码
# 创建项目目录
mkdir /home/{用户}/project/

# 拉取代码
cd project
git clone git@gitee.com:jwbh/jwschain-server.git
git clone git@gitee.com:jwbh/jwschain-docker.git


三 . 布署
#配置mysql
#创建mysql 数据存储目录
cp docker-compose.yml.dist docker-compose.yml
mkdir /home/{user}/data
修改docker-comose.yml找到/var/lib/mysql:cached一行, 将绝对路径写在最前方
docker-compose up -d mysql
docker exec -it mysql bash
mysql -uroot -p # 注意, 此处要输入密码
create database jwschain charset utf8mb4;

# 布置代码
cd jwschain-docker
mkdir logs/jwschain
cd logs/jwschain
touch container_start.log fpm_error.log nginx_access.log nginx_error.log
cd ../../conf/nginx/vhost

# 域名自己起名儿
cp example xxx.conf # 完成后编辑文件内容的域名
完成后 回到 jwschain-docker 项目目录
vim docker-compose.yml #nginx 指定用户ID
docker-compose up -d jwschain

# 代码
cd jwschain-server
chmod -R 777 bootstrap/cache
chmod -R 777 storage
docker exec -it jwschain zsh
cd /www/wwwroot
composer install
cp .env.example .env
php artisan key:generate
```

#### 使用说明
```
docker-compose up -d jwschain
```


#### 参与贡献

1.  git checkout -b 分支名
2.  git add .
3.  git commit -m '#{任务名}　任务备注'
4.  git push origin 分支名


#### 项目目录结构
```
|---conf  配置文件目录
|   |---crontab　定时任务配置文件
|   |---frp　内网穿透配置文件
|   |---mongo　mongo配置文件
|   |---mysql　mysql配置文件
|   |---nginx　nginx配置文件
|   |---php7　php7配置文件
|   |---php8　php8配置文件
|   |---redis　redis配置文件
|   |---supervisor　supervisor配置文件
|---extra  docker构建镜像挂载目录
|---log  运行时日志目录
|---ssl  证书目录
|---docker-compose.yml.dist  docker-compose配置文件模板
|---Dockerfile  构建WEB服务(php7.2)镜像配置文件
|---Dockerfile-mysql　构建MYSQL服务镜像配置文件
|---Dockerfile-php7.3 构建php7.3服务镜像配置文件
|---Dockerfile-php8 构建php8.0服务镜像配置文件
|---Dockerfile-redis 构建redis服务镜像配置文件
|---kibana.yml kibana配置文件
```


安装docker 和编译docker 遇到的问题汇总


创建镜像  文件格式不正确

standard_init_linux.go:228: exec user process caused: no such file or directory

因为Dockerfile 文件编码不正确
需要linux格式，但是windows上错误
打包文件格式错误

解决办法
使用git bash 打开文件
set ff=unix  
保存并推出

修改extra 文件夹下的所有文件的编码格式为unix 
for i in `find . -type f`;do vi $i -c 'set ff=unix | wq';done




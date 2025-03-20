# docker-envs

## How To Use

***环境基于docker搭建，请确保本地已正确安装docker( version >= 20.10.16), docker compose( versions >= 2.6.0)***

***脚本适配Mac/Linux/Unix，windows环境请执行相应的bat文件***

***(Mac/Wsl下可以使用普通用户执行，Linux/Unix下使用root或具备admin组的用户执行)***

- 预下载依赖文件及镜像
进入./preload目录，执行preload.sh
```shell
./preload.sh
```
- 构建基础镜像
执行buildBaseUbuntu.sh脚本
```shell
./buildBaseUbuntu.sh
```
- 构建hosoy镜像
执行buildBaseHosoy.sh脚本
```shell
./buildBaseHosoy.sh
```
- 启动容器
```shell
docker compose -f hosoy/docker-compose.yml up -d
```
以上步骤完成后，docker中将运行着以下5个容器
```shell
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                                                                                                                                                                             NAMES
7c214844c8bc   hosoy:0.0.1   "/bin/sh -c /home/ho…"   2 minutes ago   Up 2 minutes   22/tcp, 0.0.0.0:10016->10000/tcp                                                                                                                                                                  hosoy-sparksql-1
865bc2966b3d   hosoy:0.0.1   "/bin/sh -c /home/ho…"   2 minutes ago   Up 2 minutes   0.0.0.0:61990->22/tcp, 0.0.0.0:61991->7077/tcp, 0.0.0.0:61992->8042/tcp                                                                                                                           hosoy-slave-1
45c4d9c9546d   hosoy:0.0.1   "/bin/sh -c /home/ho…"   2 minutes ago   Up 2 minutes   22/tcp, 0.0.0.0:9083->9083/tcp                                                                                                                                                                    hosoy-metastore
9458ae13e273   hosoy:0.0.1   "/bin/sh -c /home/ho…"   2 minutes ago   Up 2 minutes   0.0.0.0:4040->4040/tcp, 0.0.0.0:7077->7077/tcp, 0.0.0.0:8042->8042/tcp, 0.0.0.0:8088->8088/tcp, 0.0.0.0:9870->9870/tcp, 0.0.0.0:18080->18080/tcp, 0.0.0.0:2022->22/tcp, 0.0.0.0:28080->8080/tcp   hosoy-master
6fc09b9a99a3   mysql:8.0     "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   33060/tcp, 0.0.0.0:6612->3306/tcp                                                                                                                                                                 hosoy-metasql
```
- 验证环境

***(环境验证必须在所有的容器启动2min以后，否则部分延迟启动的容器可能状态未达到正常状态)***

1.验证HDFS
直接在浏览器上打开http://{host}:9870，其中host为部署容器的主机名/ip
2.验证Yarn
直接在浏览器上打开http://{host}:8088，其中host为部署容器的主机名/ip
3.验证Hive MetaStore
通过telnet验证端口是否正常服务即可
```shell
page@local:~/docker-envs$ telnet 127.0.0.1 9083
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
```
4.验证spark thrift server
通过telnet验证端口是否正常服务即可
```shell
page@local:~/docker-envs$ telnet 127.0.0.1 10016
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
```
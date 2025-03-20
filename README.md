# Hosoy - 大数据开发环境

## 项目介绍

Hosoy是一个基于Docker的大数据开发环境，集成了Hadoop、Hive和Spark等组件，为大数据开发和测试提供了一个完整的解决方案。该环境通过Docker容器化技术，使得部署和使用变得简单高效。

## 环境组件

本项目集成了以下组件：

| 组件 | 版本 | 说明 |
| --- | --- | --- |
| Hadoop | 3.3.2 | 分布式存储和计算框架 |
| Hive | 3.1.3 | 基于Hadoop的数据仓库工具 |
| Spark | 3.3.2 | 大数据处理引擎 |
| MySQL | 8.0 | 用于Hive元数据存储 |
| Ubuntu | 24.04 | 基础操作系统 |

## 系统要求

- Docker: 版本 >= 20.10.16
- Docker Compose: 版本 >= 2.6.0
- 操作系统支持：
  - Mac/Linux/Unix: 使用shell脚本
  - Windows: 使用相应的bat文件
- 用户权限：
  - Mac/WSL: 可使用普通用户执行
  - Linux/Unix: 需使用root或具备admin组的用户执行

## 安装步骤

### 1. 预下载依赖文件及镜像

进入`./preload`目录，执行preload.sh脚本下载所需的组件包和Docker镜像：

```shell
./preload.sh
```

该脚本会下载以下内容：
- Hadoop 3.3.2
- Hive 3.1.3
- Spark 3.3.2
- Ubuntu 24.04镜像
- MySQL 8.0镜像

### 2. 构建基础镜像

执行buildBaseUbuntu.sh脚本，构建基础Ubuntu镜像：

```shell
./buildBaseUbuntu.sh
```

### 3. 构建Hosoy镜像

执行buildBaseHosoy.sh脚本，构建包含Hadoop、Hive和Spark的Hosoy镜像：

```shell
./buildBaseHosoy.sh
```

### 4. 启动容器

使用Docker Compose启动所有服务：

```shell
 docker compose -f hosoy/docker-compose.yml up -d
```

## 容器服务说明

启动后，将运行以下5个容器：

1. **hosoy-master**: Hadoop主节点，运行NameNode和ResourceManager
   - 端口: 2022(SSH), 7077(Spark), 8088(YARN), 4040(Spark UI), 28080(Spark Master), 8042(NodeManager), 18080(History Server), 9870(HDFS)

2. **hosoy-metasql**: MySQL数据库，用于Hive元数据存储
   - 端口: 6612(MySQL)

3. **hosoy-metastore**: Hive元数据服务
   - 端口: 9083(Metastore)

4. **hosoy-slave**: Hadoop从节点，运行DataNode和NodeManager
   - 端口: 22(SSH), 7177(Spark Worker), 7077(Spark), 8042(NodeManager)

5. **hosoy-sparksql**: Spark SQL Thrift服务器
   - 端口: 10016(Thrift)

## 环境验证

**注意：环境验证必须在所有容器启动2分钟以后进行，否则部分延迟启动的容器可能尚未达到正常状态。**

### 1. 验证HDFS

在浏览器中打开：`http://{host}:9870`

其中`{host}`为部署容器的主机名或IP地址。

### 2. 验证YARN

在浏览器中打开：`http://{host}:8088`

### 3. 验证Hive MetaStore

通过telnet验证端口是否正常服务：

```shell
telnet {host} 9083
```

成功连接示例：
```
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
```

### 4. 验证Spark Thrift Server

通过telnet验证端口是否正常服务：

```shell
telnet {host} 10016
```

## 目录结构

```
./
├── configs/                  # 配置文件目录
│   ├── hadoop/              # Hadoop配置
│   ├── hive/                # Hive配置
│   └── spark/               # Spark配置
├── hosoy/                   # 主项目目录
│   └── docker-compose.yml   # Docker Compose配置
├── preload/                 # 预加载脚本和依赖
│   └── preload.sh           # 下载依赖脚本
├── scripts/                 # 启动脚本
│   ├── entrypoints.sh       # 容器入口脚本
│   ├── run-master.sh        # 主节点启动脚本
│   ├── run-metastore.sh     # 元数据服务启动脚本
│   ├── run-slave.sh         # 从节点启动脚本
│   └── run-sparksql.sh      # SparkSQL启动脚本
├── Dockerfile-BaseUbuntu    # 基础Ubuntu镜像构建文件
├── Dockerfile-Hosoy         # Hosoy镜像构建文件
├── buildBaseHosoy.sh        # Hosoy镜像构建脚本
└── buildBaseUbuntu.sh       # 基础镜像构建脚本
```

## 使用说明

1. 连接到Hadoop集群：可通过SSH连接到master节点
   ```shell
   ssh -p 2022 hosoy@{host}
   # 默认密码: hosoy
   ```

2. 访问HDFS：通过Web UI或命令行
   ```shell
   # 在容器内
   hdfs dfs -ls /
   ```

3. 使用Hive：
   ```shell
   # 在master容器内
   hive
   ```

4. 使用Spark：
   ```shell
   # 在master容器内启动Spark Shell
   spark-shell --master yarn
   ```

5. 使用Spark SQL：
   ```shell
   # 通过JDBC连接到Thrift服务器
   # 连接URL: jdbc:hive2://{host}:10016
   ```

## 注意事项

- 所有服务的启动需要一定时间，请耐心等待
- 首次启动时，Hive元数据初始化可能需要较长时间
- 如需停止所有服务，可执行：
  ```shell
  docker compose -f hosoy/docker-compose.yml down
  ```

## 组件版本升级指南

如果需要升级Hadoop、Hive或Spark等组件的版本，请按照以下步骤操作：

### 1. 修改组件版本变量

编辑`preload/preload.sh`文件，修改相应组件的版本号：

```shell
export VERSION_HADOOP=3.3.2  # 修改为目标Hadoop版本
export VERSION_HIVE=3.1.3    # 修改为目标Hive版本
export VERSION_SPARK=3.3.2   # 修改为目标Spark版本
```

### 2. 更新Dockerfile

编辑`Dockerfile-Hosoy`文件，确保版本号与`preload.sh`中的一致：

```shell
# 修改Hadoop版本
ENV HADOOP_VERSION 3.3.2  # 修改为与preload.sh相同的版本

# 修改Spark版本
ENV SPARK_VERSION 3.3.2   # 修改为与preload.sh相同的版本

# 修改Hive版本
ENV HIVE_VERSION 3.1.3    # 修改为与preload.sh相同的版本
```

### 3. 更新镜像版本号（可选）

如果需要更新镜像版本号，请修改以下文件中的版本标签：

- `buildBaseUbuntu.sh`：修改`hosoy-ubuntu:0.0.2`中的版本号
- `buildBaseHosoy.sh`：修改`hosoy:0.0.2`中的版本号
- `hosoy/docker-compose.yml`：修改所有服务中的`image: hosoy:0.0.2`版本号

### 4. 重新下载组件包

执行预下载脚本，获取新版本的组件包：

```shell
cd ./preload
./preload.sh
```

### 5. 重新构建镜像

```shell
# 构建基础Ubuntu镜像
./buildBaseUbuntu.sh

# 构建Hosoy镜像
./buildBaseHosoy.sh
```

### 6. 重新启动容器

```shell
docker compose -f hosoy/docker-compose.yml down  # 如果有正在运行的容器，先停止
docker compose -f hosoy/docker-compose.yml up -d
```

### 7. 版本兼容性注意事项

- **Hadoop与Spark兼容性**：确保选择的Spark版本与Hadoop版本兼容。例如，Spark 3.3.x通常与Hadoop 3.x兼容。
- **Hive与Hadoop兼容性**：Hive版本需要与Hadoop版本兼容，通常Hive 3.x与Hadoop 3.x兼容。
- **Java版本要求**：不同版本的组件可能对Java版本有不同要求，请查阅官方文档确认兼容性。
- **配置文件调整**：新版本可能引入新的配置参数或废弃旧参数，可能需要相应调整`configs`目录下的配置文件。
- **数据迁移**：升级前建议备份重要数据，特别是Hive元数据和HDFS数据。
# Kafka Manager 连接本地Kafka集群指南

## 🎯 概述

本指南说明如何使用Kafka Manager连接本地启动的Kafka和Zookeeper服务，而不是Docker容器中的服务。

## 🚀 快速启动

### 方法1：使用gum脚本（推荐）
```bash
./kafka-dev.sh
# 选择 "🔗 连接本地Kafka"
```

### 方法2：直接启动
```bash
./start-kafka-manager-local.sh
```

## 📋 前置条件

### 1. 启动本地Kafka和Zookeeper
在连接Kafka Manager之前，需要先启动本地的Kafka和Zookeeper服务：

```bash
./kafka-dev.sh
# 选择 "🚀 一键启动环境"
```

### 2. 验证服务状态
确保以下端口正在监听：
- **Zookeeper**: 端口 2181
- **Kafka**: 端口 9092

```bash
# 检查端口状态
netstat -an | grep -E "(2181|9092)"
```

## 🔧 配置说明

### Docker Compose配置
使用 `docker/docker-compose-kafka-manager-local.yml` 配置文件：

```yaml
version: '2'
services:
  kafka-manager:
    image: sheepkiller/kafka-manager:2.0.0.2  # 使用支持Kafka 0.10.0的版本
    ports:
      - "9000:9000"
    environment:
      ZK_HOSTS: host.docker.internal:2181  # 连接本地Zookeeper
      APPLICATION_SECRET: "letmein"
      KAFKA_MANAGER_AUTH_ENABLED: "false"
    extra_hosts:
      - "host.docker.internal:host-gateway"  # 允许Docker访问宿主机
```

### 关键配置说明
- `ZK_HOSTS: host.docker.internal:2181`: 连接本地Zookeeper
- `extra_hosts`: 允许Docker容器访问宿主机服务
- 只启动Kafka Manager，不启动Kafka和Zookeeper

### ⚠️ Kafka Manager版本支持说明
- **旧版本问题**: `sheepkiller/kafka-manager:latest` 最高只支持Kafka 0.9.0.1
- **解决方案**: 使用 `sheepkiller/kafka-manager:2.0.0.2` 支持Kafka 0.10.0+
- **版本兼容性**: 确保Kafka Manager版本与Kafka版本匹配

## 📝 使用步骤

### 1. 启动本地Kafka服务
```bash
./kafka-dev.sh
# 选择 "🚀 一键启动环境"
```

### 2. 启动Kafka Manager
```bash
./kafka-dev.sh
# 选择 "🔗 连接本地Kafka"
```

### 3. 配置集群
1. 打开浏览器访问：http://localhost:9000
2. 点击 "Cluster" -> "Add Cluster"
3. 填写集群信息：
   - **Cluster Name**: `kafka-local-0.10.0`
   - **Zookeeper Hosts**: `host.docker.internal:2181`
   - **Kafka Version**: `0.10.0.0`
   - **Enable JMX Polling**: 勾选
4. 点击 "Save" 保存

### 4. 查看集群信息
1. 在集群列表中选择刚创建的集群
2. 可以查看：
   - 集群概览
   - Broker信息
   - Topic列表
   - 消费者组

## 🔍 功能特性

### 连接本地服务
- ✅ 连接本地Zookeeper (localhost:2181)
- ✅ 连接本地Kafka (localhost:9092)
- ✅ 查看本地topic和消息
- ✅ 监控本地集群状态

### 自动配置
- ✅ 自动检查本地服务状态
- ✅ 自动创建测试topic
- ✅ 自动发送测试消息
- ✅ 提供详细的使用说明

## 🛠️ 故障排除

### 常见问题

1. **无法连接本地Kafka**
   - 检查本地Kafka是否运行：`netstat -an | grep 9092`
   - 检查本地Zookeeper是否运行：`netstat -an | grep 2181`
   - 确保Docker可以访问宿主机：`host.docker.internal`

2. **Kafka Manager启动失败**
   - 检查Docker是否运行
   - 检查端口9000是否被占用
   - 查看日志：`docker-compose -f docker/docker-compose-kafka-manager-local.yml logs`

3. **看不到本地topic**
   - 确认本地Kafka服务正常运行
   - 检查topic是否已创建：`./bin/kafka-topics.sh --list --zookeeper localhost:2181`
   - 确认Zookeeper连接配置正确

### 查看日志
```bash
# 查看Kafka Manager日志
docker-compose -f docker/docker-compose-kafka-manager-local.yml logs kafka-manager

# 查看本地Kafka日志
tail -f /tmp/kafka.log

# 查看本地Zookeeper日志
tail -f /tmp/zookeeper.log
```

## 🔄 服务管理

### 启动服务
```bash
# 启动本地Kafka和Zookeeper
./kafka-dev.sh
# 选择 "🚀 一键启动环境"

# 启动Kafka Manager
./kafka-dev.sh
# 选择 "🔗 连接本地Kafka"
```

### 停止服务
```bash
# 停止Kafka Manager
docker-compose -f docker/docker-compose-kafka-manager-local.yml down

# 停止本地Kafka和Zookeeper
./kafka-dev.sh
# 选择 "🛑 停止环境"
```

## 📊 优势对比

### 连接本地Kafka vs Docker Kafka

| 特性 | 本地Kafka | Docker Kafka |
|------|-----------|--------------|
| 性能 | 更高 | 较低 |
| 资源占用 | 更少 | 更多 |
| 调试便利性 | 更好 | 一般 |
| 源码学习 | 更直接 | 需要映射 |
| 配置灵活性 | 更高 | 受限 |

## 🎉 总结

通过Kafka Manager连接本地Kafka集群，您可以：

- ✅ **直接管理本地Kafka服务**
- ✅ **查看本地topic和消息内容**
- ✅ **监控本地集群状态**
- ✅ **进行源码学习和调试**
- ✅ **享受更好的性能和资源利用率**

这种方式特别适合Kafka源码学习和开发调试！

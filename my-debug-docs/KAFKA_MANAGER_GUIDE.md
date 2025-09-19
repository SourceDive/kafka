# Kafka Manager 可视化界面使用指南

## 🎯 概述

Kafka Manager是一个功能强大的Kafka集群管理工具，提供Web界面来管理Kafka集群、查看topic、监控消费者组等。

## 🚀 快速启动

### 方法1：使用gum脚本（推荐）
```bash
./kafka-dev.sh
# 选择 "🌐 启动可视化界面"
```

### 方法2：直接启动
```bash
./start-kafka-manager.sh
```

## 📋 使用步骤

### 1. 访问Kafka Manager
- 打开浏览器访问：http://localhost:9000

### 2. 添加集群
1. 点击左侧菜单 "Cluster" -> "Add Cluster"
2. 填写集群信息：
   - **Cluster Name**: `kafka-0.10.0`
   - **Zookeeper Hosts**: `localhost:2181`
   - **Kafka Version**: `0.10.0.0`
   - **Enable JMX Polling**: 勾选
3. 点击 "Save" 保存配置

### 3. 查看集群信息
1. 在集群列表中选择刚创建的集群
2. 可以查看：
   - 集群概览
   - Broker信息
   - Topic列表
   - 消费者组

### 4. 查看Topic消息
1. 点击 "Topics" 标签
2. 找到 `my-debug-topic`
3. 点击topic名称进入详情页
4. 可以查看：
   - Topic配置
   - 分区信息
   - 消息内容
   - 消费者组信息

## 🔍 主要功能

### Topic管理
- 查看所有topic
- 创建/删除topic
- 查看topic配置
- 查看分区信息
- 查看消息内容

### 消费者组管理
- 查看所有消费者组
- 查看消费者组状态
- 查看消费进度
- 重置offset

### 集群监控
- 查看Broker状态
- 监控集群健康状态
- 查看JMX指标

## 📊 查看消息内容

### 方法1：通过Topic页面
1. 在Topic列表中找到 `my-debug-topic`
2. 点击topic名称
3. 在详情页可以看到消息统计

### 方法2：通过消费者组
1. 点击 "Consumer" 标签
2. 查看消费者组列表
3. 点击消费者组查看消费进度

## 🛠️ 故障排除

### 常见问题

1. **无法访问Kafka Manager**
   - 检查Docker是否运行
   - 检查端口9000是否被占用
   - 查看日志：`docker-compose -f docker/docker-compose-kafka-manager.yml logs`

2. **无法连接Kafka集群**
   - 检查Zookeeper是否运行
   - 检查Kafka是否运行
   - 确认端口配置正确

3. **看不到消息**
   - 确认topic已创建
   - 检查消息是否已发送
   - 确认消费者组配置正确

### 查看日志
```bash
# 查看Kafka Manager日志
docker-compose -f docker/docker-compose-kafka-manager.yml logs kafka-manager

# 查看Kafka日志
docker-compose -f docker/docker-compose-kafka-manager.yml logs kafka

# 查看Zookeeper日志
docker-compose -f docker/docker-compose-kafka-manager.yml logs zookeeper
```

## 🔧 高级配置

### 环境变量
- `ZK_HOSTS`: Zookeeper连接地址
- `APPLICATION_SECRET`: 应用密钥
- `KAFKA_MANAGER_AUTH_ENABLED`: 是否启用认证

### 集群配置
- 支持多集群管理
- 支持不同Kafka版本
- 支持JMX监控

## 📚 相关文档

- [Kafka Manager GitHub](https://github.com/yahoo/kafka-manager)
- [Kafka 0.10.0 文档](https://kafka.apache.org/0100/documentation.html)
- [Docker Compose 文档](https://docs.docker.com/compose/)

## 🎉 总结

Kafka Manager提供了完整的Kafka集群管理功能，特别适合：
- 开发和测试环境
- 集群监控和管理
- Topic和消息查看
- 消费者组管理

通过这个可视化界面，您可以更直观地了解Kafka集群的运行状态和消息流转情况。

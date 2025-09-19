# Docker方式启动Kafka环境

使用Docker启动Kafka环境比本地安装更简单、更可靠，也更接近生产环境。

## 方案选择

### 方案1：使用Kafka 0.10.0版本（推荐）
使用与您源码版本一致的Kafka 0.10.0：

```bash
# 启动Kafka 0.10.0环境
docker-compose -f docker-compose-kafka-0.10.yml up -d

# 查看服务状态
docker-compose -f docker-compose-kafka-0.10.yml ps

# 停止服务
docker-compose -f docker-compose-kafka-0.10.yml down
```

### 方案2：使用最新版本Kafka（可选）
使用最新版本的Kafka，包含Web UI：

```bash
# 启动最新版本Kafka环境
docker-compose up -d

# 查看服务状态
docker-compose ps

# 停止服务
docker-compose down
```

## 快速开始

### 1. 启动环境
```bash
# 使用Kafka 0.10.0版本（推荐）
docker-compose -f docker-compose-kafka-0.10.yml up -d
```

### 2. 验证服务
```bash
# 检查容器状态
docker ps

# 检查端口
netstat -an | grep -E "(2181|9092)"

# 测试Kafka连接
docker exec kafka-0.10-broker kafka-topics --list --bootstrap-server localhost:9092
```

### 3. 运行测试程序
```bash
# 编译测试模块
./gradlew :my-debug-module:build

# 运行测试
./gradlew :my-debug-module:test
```

## Docker优势

### 1. 环境隔离
- 不污染本地环境
- 版本一致性
- 快速重置

### 2. 配置简单
- 一键启动
- 预配置好的参数
- 无需手动配置Zookeeper

### 3. 监控友好
- 容器状态清晰
- 日志集中管理
- 资源使用可控

## 常用命令

### 启动和停止
```bash
# 启动服务
docker-compose -f docker-compose-kafka-0.10.yml up -d

# 停止服务
docker-compose -f docker-compose-kafka-0.10.yml down

# 重启服务
docker-compose -f docker-compose-kafka-0.10.yml restart

# 查看日志
docker-compose -f docker-compose-kafka-0.10.yml logs -f
```

### 管理主题
```bash
# 创建主题
docker exec kafka-0.10-broker kafka-topics --create --topic my-debug-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# 列出主题
docker exec kafka-0.10-broker kafka-topics --list --bootstrap-server localhost:9092

# 查看主题详情
docker exec kafka-0.10-broker kafka-topics --describe --topic my-debug-topic --bootstrap-server localhost:9092
```

### 测试消息
```bash
# 发送消息
docker exec -it kafka-0.10-broker kafka-console-producer --topic my-debug-topic --bootstrap-server localhost:9092

# 消费消息
docker exec -it kafka-0.10-broker kafka-console-consumer --topic my-debug-topic --bootstrap-server localhost:9092 --from-beginning
```

## 监控和调试

### 查看容器状态
```bash
# 查看所有容器
docker ps

# 查看特定容器日志
docker logs kafka-0.10-broker
docker logs kafka-0.10-zookeeper
```

### 进入容器调试
```bash
# 进入Kafka容器
docker exec -it kafka-0.10-broker bash

# 进入Zookeeper容器
docker exec -it kafka-0.10-zookeeper bash
```

### 清理环境
```bash
# 停止并删除容器
docker-compose -f docker-compose-kafka-0.10.yml down

# 删除数据卷（清理所有数据）
docker-compose -f docker-compose-kafka-0.10.yml down -v

# 删除镜像（可选）
docker rmi confluentinc/cp-kafka:0.10.0.0
docker rmi confluentinc/cp-zookeeper:3.4.0
```

## 故障排除

### 常见问题

#### 1. 端口冲突
```bash
# 检查端口占用
lsof -i :2181
lsof -i :9092

# 修改docker-compose.yml中的端口映射
ports:
  - "2182:2181"  # 改为2182
  - "9093:9092"  # 改为9093
```

#### 2. 容器启动失败
```bash
# 查看详细日志
docker-compose -f docker-compose-kafka-0.10.yml logs

# 检查Docker资源
docker system df
docker system prune  # 清理无用资源
```

#### 3. 连接超时
```bash
# 检查网络
docker network ls
docker network inspect kafka_default

# 重启网络
docker-compose -f docker-compose-kafka-0.10.yml down
docker-compose -f docker-compose-kafka-0.10.yml up -d
```

## 性能优化

### 资源限制
```yaml
# 在docker-compose.yml中添加资源限制
services:
  kafka:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
        reservations:
          memory: 512M
          cpus: '0.25'
```

### 数据持久化
```yaml
# 数据卷配置
volumes:
  kafka-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /path/to/your/kafka/data
```

## 总结

使用Docker启动Kafka环境有以下优势：

1. **简单快速**：一条命令启动完整环境
2. **版本一致**：与源码版本完全匹配
3. **环境隔离**：不影响本地系统
4. **易于管理**：启动、停止、重置都很简单
5. **监控友好**：容器状态清晰可见

推荐使用`docker-compose-kafka-0.10.yml`方案，因为它与您的Kafka 0.10.0源码版本完全一致。

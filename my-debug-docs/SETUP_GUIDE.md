# Kafka 0.10.0 本地环境准备指南

在运行测试程序之前，需要完成以下准备工作：

## 1. 启动Zookeeper

Zookeeper是Kafka的依赖组件，用于管理集群元数据。

### 启动命令：
```bash
# 在项目根目录下执行
./bin/zookeeper-server-start.sh config/zookeeper.properties
```

### 验证Zookeeper是否启动成功：
```bash
# 检查Zookeeper进程
ps aux | grep zookeeper

# 检查端口2181是否被监听
netstat -an | grep 2181
# 或者
lsof -i :2181
```

## 2. 启动Kafka Broker

Kafka服务器是消息队列的核心组件。

### 启动命令：
```bash
# 在项目根目录下执行
./bin/kafka-server-start.sh config/server.properties
```

### 验证Kafka是否启动成功：
```bash
# 检查Kafka进程
ps aux | grep kafka

# 检查端口9092是否被监听
netstat -an | grep 9092
# 或者
lsof -i :9092
```

## 3. 创建测试主题（可选）

虽然程序会自动创建主题，但也可以手动创建：

```bash
# 创建主题
./bin/kafka-topics.sh --create --topic my-debug-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# 查看主题列表
./bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# 查看主题详情
./bin/kafka-topics.sh --describe --topic my-debug-topic --bootstrap-server localhost:9092
```

## 4. 编译测试模块

在运行测试程序之前，需要先编译：

```bash
# 编译my-debug-module
./gradlew :my-debug-module:build

# 或者使用本地Gradle
/Users/zero/.gradle/wrapper/dists/gradle-4.10.3-bin/17kn2pci7p1fti6spjamguk0u/gradle-4.10.3/bin/gradle :my-debug-module:build
```

## 5. 运行测试程序

### 方法1：使用Gradle运行
```bash
# 运行单元测试
./gradlew :my-debug-module:test

# 运行特定测试
./gradlew :my-debug-module:test --tests KafkaCodeReaderTest
```

### 方法2：直接运行Java程序
```bash
# 编译后运行
java -cp my-debug-module/build/classes/main:clients/build/libs/kafka-clients-0.10.0.0.jar org.apache.kafka.debug.SimpleKafkaTest
```

## 6. 监控和调试

### 查看Kafka日志：
```bash
# Kafka日志位置（默认）
tail -f /tmp/kafka-logs/server.log

# 或者查看控制台输出
```

### 查看Zookeeper日志：
```bash
# Zookeeper日志位置（默认）
tail -f /tmp/zookeeper/zookeeper.out
```

## 7. 停止服务

测试完成后，停止服务：

```bash
# 停止Kafka
./bin/kafka-server-stop.sh

# 停止Zookeeper
./bin/zookeeper-server-stop.sh
```

## 常见问题

### Q1: 端口被占用怎么办？
```bash
# 查看端口占用
lsof -i :2181  # Zookeeper端口
lsof -i :9092  # Kafka端口

# 杀死占用进程
kill -9 <PID>
```

### Q2: 启动失败怎么办？
1. 检查Java版本：`java -version`（需要JDK 8）
2. 检查端口是否被占用
3. 查看错误日志
4. 确保有足够的磁盘空间

### Q3: 连接失败怎么办？
1. 确认Zookeeper和Kafka都已启动
2. 检查防火墙设置
3. 确认配置文件中的地址和端口正确

## 快速启动脚本

创建一个快速启动脚本：

```bash
#!/bin/bash
# start-kafka.sh

echo "启动Zookeeper..."
./bin/zookeeper-server-start.sh config/zookeeper.properties &
sleep 5

echo "启动Kafka..."
./bin/kafka-server-start.sh config/server.properties &
sleep 5

echo "Kafka环境已准备就绪！"
echo "Zookeeper: localhost:2181"
echo "Kafka: localhost:9092"
```

## 验证环境

运行以下命令验证环境是否正确：

```bash
# 检查服务状态
./bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# 如果返回空列表，说明环境正常
```

现在您可以运行测试程序了！

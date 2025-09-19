#!/bin/bash

# Kafka 0.10.0 本地启动脚本
# 用于源码学习和调试

echo "=== 启动Kafka 0.10.0本地环境 ==="

# 检查Java版本
echo "检查Java版本..."
java -version

# 创建必要的目录
echo "创建数据目录..."
mkdir -p /tmp/zookeeper
mkdir -p /tmp/kafka-logs

# 启动Zookeeper
echo "启动Zookeeper..."
./bin/zookeeper-server-start.sh config/zookeeper.properties &
ZOOKEEPER_PID=$!

# 等待Zookeeper启动
echo "等待Zookeeper启动..."
sleep 5

# 检查Zookeeper是否启动成功
if ! netstat -an | grep -q :2181; then
    echo "错误：Zookeeper启动失败"
    exit 1
fi

echo "Zookeeper启动成功 (PID: $ZOOKEEPER_PID)"

# 启动Kafka
echo "启动Kafka..."
./bin/kafka-server-start.sh config/server.properties &
KAFKA_PID=$!

# 等待Kafka启动
echo "等待Kafka启动..."
sleep 10

# 检查Kafka是否启动成功
if ! netstat -an | grep -q :9092; then
    echo "错误：Kafka启动失败"
    kill $ZOOKEEPER_PID
    exit 1
fi

echo "Kafka启动成功 (PID: $KAFKA_PID)"

# 创建测试主题
echo "创建测试主题..."
./bin/kafka-topics.sh --create --topic my-debug-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1 2>/dev/null || echo "主题可能已存在"

echo ""
echo "=== 环境准备完成 ==="
echo "Zookeeper: localhost:2181 (PID: $ZOOKEEPER_PID)"
echo "Kafka: localhost:9092 (PID: $KAFKA_PID)"
echo ""
echo "现在可以运行测试程序了！"
echo ""
echo "停止服务请运行: ./stop-kafka-local.sh"

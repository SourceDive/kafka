#!/bin/bash

# Kafka 0.10.0 本地停止脚本

echo "=== 停止Kafka 0.10.0本地环境 ==="

# 停止Kafka
echo "停止Kafka..."
./bin/kafka-server-stop.sh

# 停止Zookeeper
echo "停止Zookeeper..."
./bin/zookeeper-server-stop.sh

# 等待进程完全停止
sleep 3

# 检查是否还有残留进程
KAFKA_PIDS=$(ps aux | grep kafka | grep -v grep | awk '{print $2}')
ZOOKEEPER_PIDS=$(ps aux | grep zookeeper | grep -v grep | awk '{print $2}')

if [ ! -z "$KAFKA_PIDS" ]; then
    echo "强制停止Kafka进程: $KAFKA_PIDS"
    kill -9 $KAFKA_PIDS
fi

if [ ! -z "$ZOOKEEPER_PIDS" ]; then
    echo "强制停止Zookeeper进程: $ZOOKEEPER_PIDS"
    kill -9 $ZOOKEEPER_PIDS
fi

echo "=== 环境已停止 ==="

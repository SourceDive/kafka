#!/bin/bash

# 检查gum是否安装
if ! command -v gum &> /dev/null; then
    echo "❌ gum未安装，请先安装gum: brew install gum"
    exit 1
fi

gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🎯 Kafka Manager 连接本地Kafka集群"

# 检查Docker是否运行
if ! docker info &> /dev/null; then
    gum style --foreground=red "❌ Docker未运行，请先启动Docker"
    exit 1
fi

# 检查本地Kafka和Zookeeper是否运行
gum style --foreground=blue "🔍 检查本地Kafka和Zookeeper服务状态..."

# 检查Zookeeper
if ! netstat -an | grep -q "2181.*LISTEN"; then
    gum style --foreground=red "❌ 本地Zookeeper未运行，请先启动Zookeeper"
    gum style --foreground=yellow "💡 提示：运行 ./kafka-dev.sh 选择 '🚀 一键启动环境' 来启动本地服务"
    exit 1
fi

# 检查Kafka
if ! netstat -an | grep -q "9092.*LISTEN"; then
    gum style --foreground=red "❌ 本地Kafka未运行，请先启动Kafka"
    gum style --foreground=yellow "💡 提示：运行 ./kafka-dev.sh 选择 '🚀 一键启动环境' 来启动本地服务"
    exit 1
fi

gum style --foreground=green "✅ 本地Kafka和Zookeeper服务正常运行"

# 启动Kafka Manager
gum style --foreground=blue "🚀 启动Kafka Manager连接本地集群..."
cd docker
docker-compose -f docker-compose-kafka-manager-local.yml up -d

# 等待服务启动
gum spin --title="等待Kafka Manager启动..." -- sleep 15

# 检查服务状态
if docker-compose -f docker-compose-kafka-manager-local.yml ps | grep -q "Up"; then
    gum style --foreground=green "✅ Kafka Manager启动成功！"
    gum style --foreground=blue "🌐 访问地址: http://localhost:9000"
    gum style --foreground=yellow "📝 使用说明:"
    echo "  1. 打开浏览器访问 http://localhost:9000"
    echo "  2. 在左侧菜单选择 'Cluster' -> 'Add Cluster'"
    echo "  3. 配置集群信息:"
    echo "     - Cluster Name: kafka-local-0.10.0"
    echo "     - Zookeeper Hosts: host.docker.internal:2181"
    echo "     - Kafka Version: 0.10.0.0"
    echo "     - Enable JMX Polling: 勾选"
    echo "  4. 点击 'Save' 保存配置"
    echo "  5. 在集群列表中选择刚创建的集群"
    echo "  6. 点击 'Topics' 查看所有topic"
    echo "  7. 找到 'my-debug-topic' 并点击查看消息"
    
    # 检查本地topic是否存在
    gum style --foreground=green "📋 检查本地topic状态..."
    if ./bin/kafka-topics.sh --list --zookeeper localhost:2181 | grep -q "my-debug-topic"; then
        gum style --foreground=green "✅ 本地topic 'my-debug-topic' 已存在"
    else
        gum style --foreground=yellow "⚠️  本地topic 'my-debug-topic' 不存在，正在创建..."
        ./bin/kafka-topics.sh --create --topic my-debug-topic --zookeeper localhost:2181 --partitions 1 --replication-factor 1
        gum style --foreground=green "✅ 本地topic 'my-debug-topic' 创建成功"
    fi
    
    # 发送一些测试消息到本地Kafka
    gum style --foreground=green "📤 发送测试消息到本地Kafka..."
    for i in {1..5}; do
        echo "本地测试消息 $i" | ./bin/kafka-console-producer.sh --topic my-debug-topic --broker-list localhost:9092
    done
    
    gum style --foreground=green "✅ 测试消息已发送到本地Kafka，请在Kafka Manager中查看"
    
else
    gum style --foreground=red "❌ Kafka Manager启动失败"
    docker-compose -f docker-compose-kafka-manager-local.yml logs
fi

cd ..

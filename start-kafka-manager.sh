#!/bin/bash

# 检查gum是否安装
if ! command -v gum &> /dev/null; then
    echo "❌ gum未安装，请先安装gum: brew install gum"
    exit 1
fi

gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🎯 Kafka Manager 可视化界面启动器"

# 检查Docker是否运行
if ! docker info &> /dev/null; then
    gum style --foreground=red "❌ Docker未运行，请先启动Docker"
    exit 1
fi

# 停止现有的Kafka服务
gum style --foreground=yellow "🛑 停止现有的Kafka服务..."
pkill -f "kafka.Kafka" 2>/dev/null || true
pkill -f "QuorumPeerMain" 2>/dev/null || true

# 启动Kafka Manager
gum style --foreground=blue "🚀 启动Kafka Manager可视化界面..."
cd docker
docker-compose -f docker-compose-kafka-manager.yml up -d

# 等待服务启动
gum spin --title="等待服务启动..." -- sleep 20

# 检查服务状态
if docker-compose -f docker-compose-kafka-manager.yml ps | grep -q "Up"; then
    gum style --foreground=green "✅ Kafka Manager启动成功！"
    gum style --foreground=blue "🌐 访问地址: http://localhost:9000"
    gum style --foreground=yellow "📝 使用说明:"
    echo "  1. 打开浏览器访问 http://localhost:9000"
    echo "  2. 在左侧菜单选择 'Cluster' -> 'Add Cluster'"
    echo "  3. 配置集群信息:"
    echo "     - Cluster Name: kafka-0.10.0"
    echo "     - Zookeeper Hosts: localhost:2181"
    echo "     - Kafka Version: 0.10.0.0"
    echo "  4. 点击 'Save' 保存配置"
    echo "  5. 在集群列表中选择刚创建的集群"
    echo "  6. 点击 'Topics' 查看所有topic"
    echo "  7. 找到 'my-debug-topic' 并点击查看消息"
    
    # 创建测试topic和发送消息
    gum style --foreground=green "📤 发送测试消息..."
    docker-compose -f docker-compose-kafka-manager.yml exec kafka kafka-topics.sh --create --topic my-debug-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1 2>/dev/null || true
    
    # 发送一些测试消息
    for i in {1..5}; do
        echo "测试消息 $i" | docker-compose -f docker-compose-kafka-manager.yml exec -T kafka kafka-console-producer.sh --topic my-debug-topic --bootstrap-server localhost:9092
    done
    
    gum style --foreground=green "✅ 测试消息已发送，请在Kafka Manager中查看"
    
else
    gum style --foreground=red "❌ Kafka Manager启动失败"
    docker-compose -f docker-compose-kafka-manager.yml logs
fi

cd ..

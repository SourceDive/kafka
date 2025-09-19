#!/bin/bash

# 修复Kafka Manager连接问题的脚本

echo "🔧 修复Kafka Manager连接问题..."

# 停止Kafka Manager
echo "🛑 停止Kafka Manager..."
docker-compose -f docker/docker-compose-kafka-manager-local.yml down

# 等待一下
sleep 3

# 重新启动Kafka Manager
echo "🚀 重新启动Kafka Manager..."
docker-compose -f docker/docker-compose-kafka-manager-local.yml up -d

# 等待启动
echo "⏳ 等待Kafka Manager启动..."
sleep 15

# 检查状态
echo "📊 检查Kafka Manager状态..."
if docker-compose -f docker/docker-compose-kafka-manager-local.yml ps | grep -q "Up"; then
    echo "✅ Kafka Manager启动成功！"
    echo "🌐 访问地址: http://localhost:9000"
    echo ""
    echo "📝 配置说明:"
    echo "1. 打开浏览器访问 http://localhost:9000"
    echo "2. 点击 'Add Cluster' 添加集群"
    echo "3. 配置集群信息:"
    echo "   - Cluster Name: kafka-local-0.10.0"
    echo "   - Zookeeper Hosts: localhost:2181"
    echo "   - Kafka Version: 0.10.0.0"
    echo "   - Enable JMX Polling: 勾选"
    echo "4. 点击 'Save' 保存配置"
    echo ""
    echo "⚠️  注意: 由于使用了host网络模式，请使用localhost:2181而不是host.docker.internal:2181"
else
    echo "❌ Kafka Manager启动失败"
    echo "📋 查看日志:"
    docker-compose -f docker/docker-compose-kafka-manager-local.yml logs kafka-manager | tail -20
fi

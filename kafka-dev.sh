#!/bin/bash

# Kafka 0.10.0 开发环境一键启动脚本
# 使用 gum 提供友好的用户界面

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# 检查依赖
check_dependencies() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🔍 检查依赖环境"
    
    # 检查Java
    if ! command -v java &> /dev/null; then
        gum style --foreground=red "❌ Java未安装"
        exit 1
    fi
    
    local java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    gum style --foreground=green "✅ Java版本: $java_version"
    
    # 检查gum
    if ! command -v gum &> /dev/null; then
        gum style --foreground=red "❌ gum未安装，请先安装: brew install gum"
        exit 1
    fi
    
    # 检查Gradle
    if [ ! -f "/Users/zero/.gradle/wrapper/dists/gradle-4.10.3-bin/17kn2pci7p1fti6spjamguk0u/gradle-4.10.3/bin/gradle" ]; then
        gum style --foreground=red "❌ Gradle 4.10.3未找到"
        exit 1
    fi
    
    gum style --foreground=green "✅ 所有依赖检查通过"
}

# 构建项目
build_project() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🔨 构建Kafka项目"
    
    if [ ! -d "core/build/dependant-libs-2.10.6" ]; then
        gum spin --title="生成依赖库..." -- /Users/zero/.gradle/wrapper/dists/gradle-4.10.3-bin/17kn2pci7p1fti6spjamguk0u/gradle-4.10.3/bin/gradle copyDependantLibs
    else
        gum style --foreground=yellow "⚠️  依赖库已存在，跳过构建"
    fi
    
    gum spin --title="编译调试模块..." -- /Users/zero/.gradle/wrapper/dists/gradle-4.10.3-bin/17kn2pci7p1fti6spjamguk0u/gradle-4.10.3/bin/gradle :my-debug-module:build
    
    gum style --foreground=green "✅ 项目构建完成"
}

# 检查端口占用
check_ports() {
    local zk_port=$(lsof -ti:2181 2>/dev/null || echo "")
    local kafka_port=$(lsof -ti:9092 2>/dev/null || echo "")
    
    if [ ! -z "$zk_port" ] || [ ! -z "$kafka_port" ]; then
        gum style --foreground=yellow "⚠️  检测到端口占用:"
        [ ! -z "$zk_port" ] && gum style --foreground=red "   - 端口2181被进程$zk_port占用"
        [ ! -z "$kafka_port" ] && gum style --foreground=red "   - 端口9092被进程$kafka_port占用"
        
        if gum confirm "是否强制停止占用进程?"; then
            [ ! -z "$zk_port" ] && kill -9 $zk_port
            [ ! -z "$kafka_port" ] && kill -9 $kafka_port
            gum style --foreground=green "✅ 已清理占用进程"
        else
            gum style --foreground=red "❌ 无法启动，请手动清理端口"
            exit 1
        fi
    fi
}

# 启动Zookeeper
start_zookeeper() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🐘 启动Zookeeper"
    
    # 创建数据目录
    mkdir -p /tmp/zookeeper
    mkdir -p /tmp/kafka-logs
    
    # 启动Zookeeper
    ./bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/zookeeper.log 2>&1 &
    local zk_pid=$!
    echo $zk_pid > /tmp/zookeeper.pid
    
    # 等待启动
    gum spin --title="等待Zookeeper启动..." -- sleep 5
    
    # 检查启动状态
    if netstat -an | grep -q :2181; then
        gum style --foreground=green "✅ Zookeeper启动成功 (PID: $zk_pid)"
    else
        gum style --foreground=red "❌ Zookeeper启动失败"
        cat /tmp/zookeeper.log
        exit 1
    fi
}

# 启动Kafka
start_kafka() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🚀 启动Kafka"
    
    # 启动Kafka
    ./bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log 2>&1 &
    local kafka_pid=$!
    echo $kafka_pid > /tmp/kafka.pid
    
    # 等待启动
    gum spin --title="等待Kafka启动..." -- sleep 10
    
    # 检查启动状态
    if netstat -an | grep -q :9092; then
        gum style --foreground=green "✅ Kafka启动成功 (PID: $kafka_pid)"
    else
        gum style --foreground=red "❌ Kafka启动失败"
        cat /tmp/kafka.log
        exit 1
    fi
}

# 创建测试主题
create_test_topic() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "📝 创建测试主题"
    
    # 创建测试主题
    ./bin/kafka-topics.sh --create --topic my-debug-topic --zookeeper localhost:2181 --partitions 1 --replication-factor 1 2>/dev/null || true
    
    gum style --foreground=green "✅ 测试主题创建完成"
}

# 运行测试程序
run_test() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🧪 运行测试程序"
    
    if gum confirm "是否运行Kafka测试程序?"; then
        gum spin --title="运行测试程序..." -- java -cp "my-debug-module/build/libs/kafka-my-debug-module-0.10.0.0.jar:core/build/dependant-libs-2.10.6/*:clients/build/libs/*:tools/build/libs/*" org.apache.kafka.debug.SimpleKafkaTest
    fi
}

# 显示状态
show_status() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "📊 环境状态"
    
    echo "Zookeeper: $(netstat -an | grep :2181 | wc -l | xargs) 个连接"
    echo "Kafka: $(netstat -an | grep :9092 | wc -l | xargs) 个连接"
    echo ""
    echo "服务地址:"
    echo "  - Zookeeper: localhost:2181"
    echo "  - Kafka: localhost:9092"
    echo "  - 测试主题: my-debug-topic"
    echo ""
    echo "日志文件:"
    echo "  - Zookeeper: /tmp/zookeeper.log"
    echo "  - Kafka: /tmp/kafka.log"
}

# 停止服务
stop_services() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🛑 停止服务"
    
    # 停止Kafka
    if [ -f "/tmp/kafka.pid" ]; then
        local kafka_pid=$(cat /tmp/kafka.pid)
        kill $kafka_pid 2>/dev/null || true
        rm -f /tmp/kafka.pid
        gum style --foreground=green "✅ Kafka已停止"
    fi
    
    # 停止Zookeeper
    if [ -f "/tmp/zookeeper.pid" ]; then
        local zk_pid=$(cat /tmp/zookeeper.pid)
        kill $zk_pid 2>/dev/null || true
        rm -f /tmp/zookeeper.pid
        gum style --foreground=green "✅ Zookeeper已停止"
    fi
    
    # 清理残留进程
    pkill -f "kafka.Kafka" 2>/dev/null || true
    pkill -f "QuorumPeerMain" 2>/dev/null || true
}

# 主菜单
show_menu() {
    gum style --border=rounded --margin="1 2" --padding="2 4" --border-foreground=212 "🎯 Kafka 0.10.0 开发环境"
    
    local choice=$(gum choose "🚀 一键启动环境" "🛑 停止环境" "🧪 运行测试" "📊 查看状态" "🔧 重新构建" "❌ 退出")
    
    case $choice in
        "🚀 一键启动环境")
            check_dependencies
            build_project
            check_ports
            start_zookeeper
            start_kafka
            create_test_topic
            show_status
            run_test
            ;;
        "🛑 停止环境")
            stop_services
            ;;
        "🧪 运行测试")
            run_test
            ;;
        "📊 查看状态")
            show_status
            ;;
        "🔧 重新构建")
            build_project
            ;;
        "❌ 退出")
            gum style --foreground=blue "👋 再见！"
            exit 0
            ;;
    esac
}

# 主函数
main() {
    # 检查参数
    if [ "$1" = "start" ]; then
        check_dependencies
        build_project
        check_ports
        start_zookeeper
        start_kafka
        create_test_topic
        show_status
    elif [ "$1" = "stop" ]; then
        stop_services
    elif [ "$1" = "test" ]; then
        run_test
    elif [ "$1" = "status" ]; then
        show_status
    else
        show_menu
    fi
}

# 运行主函数
main "$@"

# Kafka 0.10.0 源码学习环境文档

## 📚 文档索引

本目录包含了Kafka 0.10.0源码学习环境的所有相关文档。

### 🔧 环境搭建文档

- **[KAFKA_COMPILATION_GUIDE.md](./KAFKA_COMPILATION_GUIDE.md)** - Kafka 0.10.0编译问题解决指南
- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - 本地环境搭建指南
- **[README_DEV.md](./README_DEV.md)** - 开发环境使用说明

### 🌐 可视化界面文档

- **[KAFKA_MANAGER_GUIDE.md](./KAFKA_MANAGER_GUIDE.md)** - Kafka Manager使用指南（Docker版本）
- **[KAFKA_MANAGER_LOCAL_GUIDE.md](./KAFKA_MANAGER_LOCAL_GUIDE.md)** - Kafka Manager连接本地Kafka指南

## 🚀 快速开始

### 1. 环境搭建
```bash
# 一键启动Kafka开发环境
./kafka-dev.sh
# 选择 "🚀 一键启动环境"
```

### 2. 可视化界面
```bash
# 连接本地Kafka的可视化界面
./kafka-dev.sh
# 选择 "🔗 连接本地Kafka"
```

### 3. 运行测试
```bash
# 运行Kafka测试程序
./kafka-dev.sh
# 选择 "🧪 运行测试"
```

## 📁 项目结构

```
kafka/
├── my-debug-docs/           # 📚 文档目录
│   ├── README.md            # 本文档
│   ├── KAFKA_COMPILATION_GUIDE.md
│   ├── SETUP_GUIDE.md
│   ├── README_DEV.md
│   ├── KAFKA_MANAGER_GUIDE.md
│   └── KAFKA_MANAGER_LOCAL_GUIDE.md
├── my-debug-module/         # 🧪 测试模块
│   ├── src/main/java/org/apache/kafka/debug/
│   │   └── SimpleKafkaTest.java
│   └── build.gradle
├── docker/                  # 🐳 Docker配置
│   ├── docker-compose-kafka-manager.yml
│   └── docker-compose-kafka-manager-local.yml
├── kafka-dev.sh            # 🎯 主启动脚本
├── start-kafka-manager-local.sh
└── bin/kafka-run-class-clean.sh
```

## 🎯 主要功能

### ✅ 环境管理
- 一键启动Kafka和Zookeeper
- 自动依赖检查
- 端口冲突处理
- 服务状态监控

### ✅ 可视化界面
- Kafka Manager Web界面
- 连接本地Kafka集群
- 查看topic和消息内容
- 集群状态监控

### ✅ 测试开发
- 简单Kafka测试程序
- 源码调试支持
- 消息发送和消费测试

### ✅ 文档支持
- 完整的搭建指南
- 问题排查文档
- 使用说明和最佳实践

## 🔧 常用命令

```bash
# 启动开发环境
./kafka-dev.sh

# 直接启动Kafka Manager连接本地
./start-kafka-manager-local.sh

# 运行测试程序
java -cp "my-debug-module/build/libs/kafka-my-debug-module-0.10.0.0.jar:core/build/dependant-libs-2.10.6/*:clients/build/libs/*:tools/build/libs/*" org.apache.kafka.debug.SimpleKafkaTest
```

## 📞 技术支持

如果遇到问题，请查看相关文档：

1. **编译问题** → `KAFKA_COMPILATION_GUIDE.md`
2. **环境搭建** → `SETUP_GUIDE.md`
3. **可视化界面** → `KAFKA_MANAGER_LOCAL_GUIDE.md`
4. **开发使用** → `README_DEV.md`

## 🎉 总结

现在您有了一个完整的Kafka 0.10.0源码学习环境，包括：

- ✅ **完整的编译环境** - 支持Kafka 0.10.0源码编译
- ✅ **可视化管理界面** - 通过Web界面管理Kafka集群
- ✅ **测试开发模块** - 简单的Kafka测试程序
- ✅ **详细文档支持** - 完整的使用和问题排查指南

开始您的Kafka源码学习之旅吧！🚀

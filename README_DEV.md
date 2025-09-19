# Kafka 0.10.0 开发环境

## 🚀 一键启动

使用新的`gum`脚本，让Kafka开发环境启动变得简单：

```bash
# 交互式菜单
./kafka-dev.sh

# 直接启动
./kafka-dev.sh start

# 停止环境
./kafka-dev.sh stop

# 运行测试
./kafka-dev.sh test

# 查看状态
./kafka-dev.sh status
```

## 📁 项目结构

```
kafka/
├── kafka-dev.sh              # 主启动脚本（使用gum）
├── my-debug-module/          # 调试模块
│   ├── src/main/java/        # 测试程序源码
│   └── build.gradle          # 模块构建配置
├── docker/                   # Docker相关文件
│   ├── docker-compose.yml
│   ├── docker-compose-kafka-0.10.yml
│   └── DOCKER_SETUP.md
├── start-kafka-local.sh      # 旧版启动脚本
├── stop-kafka-local.sh       # 旧版停止脚本
└── docs/                     # 文档
    ├── LOCAL_SETUP_FOR_DEBUGGING.md
    └── SETUP_GUIDE.md
```

## 🎯 功能特性

### 新脚本特性：
- ✅ **友好界面**：使用`gum`提供美观的交互界面
- ✅ **自动检查**：自动检查Java、Gradle、端口占用等
- ✅ **智能构建**：自动生成依赖库，跳过已存在的构建
- ✅ **进程管理**：自动管理Zookeeper和Kafka进程
- ✅ **状态监控**：实时显示服务状态和连接数
- ✅ **日志管理**：统一管理日志文件位置

### 支持的操作：
1. **🚀 一键启动环境** - 完整的启动流程
2. **🛑 停止环境** - 优雅停止所有服务
3. **🧪 运行测试** - 执行Kafka测试程序
4. **📊 查看状态** - 显示服务状态和连接信息
5. **🔧 重新构建** - 强制重新构建项目

## 🔧 环境要求

- Java 8
- Gradle 4.10.3
- gum (用于友好界面)
- 端口2181、9092可用

## 📝 使用示例

### 第一次使用：
```bash
./kafka-dev.sh
# 选择 "🚀 一键启动环境"
```

### 日常开发：
```bash
# 快速启动
./kafka-dev.sh start

# 运行测试
./kafka-dev.sh test

# 停止环境
./kafka-dev.sh stop
```

## 🐳 Docker方案

如果需要使用Docker，请查看`docker/`目录：
```bash
cd docker/
docker-compose up -d
```

## 📚 源码调试

详细调试指南请查看：
- `LOCAL_SETUP_FOR_DEBUGGING.md` - 本地调试设置
- `SETUP_GUIDE.md` - 环境搭建指南

## 🆚 新旧脚本对比

| 功能 | 旧脚本 | 新脚本 (gum) |
|------|--------|-------------|
| 界面 | 纯文本 | 美观交互 |
| 检查 | 手动 | 自动检查 |
| 构建 | 手动 | 智能构建 |
| 进程管理 | 基础 | 完善管理 |
| 状态显示 | 简单 | 详细信息 |
| 错误处理 | 基础 | 友好提示 |

## 🎉 开始使用

现在您只需要运行一个命令就能启动完整的Kafka开发环境！

```bash
./kafka-dev.sh
```

选择"🚀 一键启动环境"，脚本会自动处理所有前置条件，让您专注于源码学习！

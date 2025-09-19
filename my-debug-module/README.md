# My Debug Module

这是为学习Kafka 0.10.0源码而创建的调试模块。

## 目录结构

```
my-debug-module/
├── src/
│   ├── main/java/org/apache/kafka/debug/
│   │   └── SimpleKafkaTest.java          # 简单的Kafka测试程序
│   └── test/java/org/apache/kafka/debug/
│       └── KafkaCodeReaderTest.java      # Kafka代码阅读测试
├── build.gradle                          # 模块构建配置
└── README.md                            # 说明文档
```

## 功能说明

### SimpleKafkaTest.java
- 最简单的Kafka生产者和消费者示例
- 展示Kafka 0.10.0的基本用法
- 包含完整的配置和错误处理

### KafkaCodeReaderTest.java
- 用于学习Kafka内部实现的测试类
- 展示Kafka组件的创建过程
- 帮助理解Kafka的配置和常量

## 使用方法

### 1. 编译模块
```bash
# 编译my-debug-module
./gradlew :my-debug-module:build

# 或者使用本地Gradle
/Users/zero/.gradle/wrapper/dists/gradle-4.10.3-bin/17kn2pci7p1fti6spjamguk0u/gradle-4.10.3/bin/gradle :my-debug-module:build
```

### 2. 运行测试
```bash
# 运行单元测试
./gradlew :my-debug-module:test

# 运行特定测试
./gradlew :my-debug-module:test --tests KafkaCodeReaderTest
```

### 3. 运行主程序
```bash
# 编译后运行SimpleKafkaTest
java -cp my-debug-module/build/classes/main:clients/build/libs/kafka-clients-0.10.0.0.jar org.apache.kafka.debug.SimpleKafkaTest
```

## 学习建议

1. **从SimpleKafkaTest开始**：理解Kafka的基本概念和用法
2. **阅读KafkaCodeReaderTest**：学习Kafka内部组件的创建过程
3. **修改和实验**：尝试修改代码，观察不同的行为
4. **阅读源码**：结合Kafka源码，深入理解实现细节

## 注意事项

- 运行前需要启动Kafka服务器（localhost:9092）
- 确保Zookeeper也在运行
- 可以修改BOOTSTRAP_SERVERS配置指向实际的Kafka集群

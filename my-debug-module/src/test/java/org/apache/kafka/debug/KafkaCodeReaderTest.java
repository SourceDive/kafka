package org.apache.kafka.debug;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.junit.Test;

import java.util.Properties;

/**
 * Kafka代码阅读测试类
 * 用于学习和理解Kafka内部实现
 */
public class KafkaCodeReaderTest {
    
    @Test
    public void testProducerCreation() {
        System.out.println("=== 测试KafkaProducer创建过程 ===");
        
        // 配置生产者属性
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        
        // 创建生产者实例
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);
        
        System.out.println("KafkaProducer创建成功");
        System.out.println("配置信息:");
        System.out.println("  Bootstrap Servers: " + props.get(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG));
        System.out.println("  Key Serializer: " + props.get(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG));
        System.out.println("  Value Serializer: " + props.get(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG));
        
        producer.close();
    }
    
    @Test
    public void testProducerRecordCreation() {
        System.out.println("=== 测试ProducerRecord创建过程 ===");
        
        // 创建ProducerRecord
        String topic = "test-topic";
        String key = "test-key";
        String value = "test-value";
        
        ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, value);
        
        System.out.println("ProducerRecord创建成功");
        System.out.println("  Topic: " + record.topic());
        System.out.println("  Key: " + record.key());
        System.out.println("  Value: " + record.value());
        System.out.println("  Partition: " + record.partition());
        System.out.println("  Timestamp: " + record.timestamp());
    }
    
    @Test
    public void testKafkaConfigConstants() {
        System.out.println("=== 测试Kafka配置常量 ===");
        
        // 生产者配置常量
        System.out.println("生产者配置常量:");
        System.out.println("  BOOTSTRAP_SERVERS: " + ProducerConfig.BOOTSTRAP_SERVERS_CONFIG);
        System.out.println("  KEY_SERIALIZER: " + ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG);
        System.out.println("  VALUE_SERIALIZER: " + ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG);
        System.out.println("  ACKS: " + ProducerConfig.ACKS_CONFIG);
        System.out.println("  RETRIES: " + ProducerConfig.RETRIES_CONFIG);
        
        // 消费者配置常量
        System.out.println("消费者配置常量:");
        System.out.println("  GROUP_ID: " + org.apache.kafka.clients.consumer.ConsumerConfig.GROUP_ID_CONFIG);
        System.out.println("  AUTO_OFFSET_RESET: " + org.apache.kafka.clients.consumer.ConsumerConfig.AUTO_OFFSET_RESET_CONFIG);
    }
}

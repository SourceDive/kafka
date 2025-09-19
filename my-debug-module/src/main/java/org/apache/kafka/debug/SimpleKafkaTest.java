package org.apache.kafka.debug;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Arrays;
import java.util.Properties;
import java.util.concurrent.Future;

/**
 * 最简单的Kafka测试程序
 * 用于学习和理解Kafka的基本用法
 */
public class SimpleKafkaTest {
    
    private static final String BOOTSTRAP_SERVERS = "localhost:9092";
    private static final String TOPIC_NAME = "my-debug-topic";
    private static final String GROUP_ID = "my-debug-group";
    
    public static void main(String[] args) {
        System.out.println("=== Kafka 0.10.0 简单测试程序 ===");
        
        // 测试生产者
        testProducer();
        
        // 测试消费者
        testConsumer();
        
        System.out.println("=== 测试完成 ===");
    }
    
    /**
     * 测试Kafka生产者
     */
    public static void testProducer() {
        System.out.println("\n--- 测试生产者 ---");
        
        // 配置生产者属性
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.RETRIES_CONFIG, 3);
        
        // 创建生产者
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);
        
        try {
            // 发送消息
            for (int i = 0; i < 5; i++) {
                String key = "key-" + i;
                String value = "Hello Kafka 0.10.0! Message " + i;
                
                ProducerRecord<String, String> record = new ProducerRecord<>(TOPIC_NAME, key, value);
                Future<RecordMetadata> future = producer.send(record);
                
                System.out.println("发送消息: " + key + " -> " + value);
                
                // 等待发送完成
                RecordMetadata metadata = future.get();
                System.out.println("消息发送成功: topic=" + metadata.topic() + 
                                 ", partition=" + metadata.partition() + 
                                 ", offset=" + metadata.offset());
            }
            
        } catch (Exception e) {
            System.err.println("生产者发送消息失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            producer.close();
        }
    }
    
    /**
     * 测试Kafka消费者
     */
    public static void testConsumer() {
        System.out.println("\n--- 测试消费者 ---");
        
        // 配置消费者属性
        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, GROUP_ID);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, true);
        
        // 创建消费者
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
        
        try {
            // 订阅主题
            consumer.subscribe(Arrays.asList(TOPIC_NAME));
            System.out.println("消费者已订阅主题: " + TOPIC_NAME);
            
            // 消费消息
            int messageCount = 0;
            int pollCount = 0;
            int maxPolls = 10; // 最多轮询10次，避免无限等待
            
            while (messageCount < 5 && pollCount < maxPolls) {
                ConsumerRecords<String, String> records = consumer.poll(1000);
                pollCount++;
                
                if (records.isEmpty()) {
                    System.out.println("等待消息中... (轮询 " + pollCount + "/" + maxPolls + ")");
                    continue;
                }
                
                for (ConsumerRecord<String, String> record : records) {
                    System.out.println("收到消息: " + record.key() + " -> " + record.value());
                    System.out.println("  topic: " + record.topic());
                    System.out.println("  partition: " + record.partition());
                    System.out.println("  offset: " + record.offset());
                    System.out.println("  timestamp: " + record.timestamp());
                    System.out.println("---");
                    
                    messageCount++;
                }
            }
            
            if (messageCount == 0) {
                System.out.println("⚠️  没有收到任何消息，请检查Kafka服务是否正常运行");
            } else {
                System.out.println("✅ 成功消费了 " + messageCount + " 条消息");
            }
            
        } catch (Exception e) {
            System.err.println("消费者接收消息失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            consumer.close();
        }
    }
}

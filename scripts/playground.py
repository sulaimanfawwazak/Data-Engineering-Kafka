from kafka import KafkaProducer
import json

producer = KafkaProducer(
  bootstrap_servers=['3.26.189.164:9092'],
  value_serializer=lambda x: json.dumps(x).encode('utf-8')
)

# Send a test message
producer.send('test_topic', value={'key': 'value'})
producer.flush()
print("Message sent successfully")
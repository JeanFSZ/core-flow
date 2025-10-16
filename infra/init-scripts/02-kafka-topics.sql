-- Kafka Topics Configuration
-- This file documents the Kafka topics that will be created
-- Topics are auto-created by Kafka when first message is sent

-- CoreFlow Event Topics:
-- 1. blog.post.created     - When a new blog post is created
-- 2. blog.post.updated     - When a blog post is updated
-- 3. blog.post.deleted     - When a blog post is deleted
-- 4. ai.blog.generated     - When AI generates new content
-- 5. ai.blog.enhanced      - When AI enhances existing content
-- 6. tx.submitted          - When a transaction is submitted to blockchain
-- 7. tx.confirmed          - When a transaction is confirmed on blockchain
-- 8. user.authenticated    - When a user logs in
-- 9. user.registered       - When a new user registers
-- 10. payment.processed    - When a payment is processed

-- Note: Topics will be created automatically by Kafka
-- when the first message is published to each topic.

-- To manually create topics (if needed), use:
-- docker exec coreflow-kafka kafka-topics --create --topic blog.post.created --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic blog.post.updated --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic blog.post.deleted --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic ai.blog.generated --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic ai.blog.enhanced --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic tx.submitted --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic tx.confirmed --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic user.authenticated --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic user.registered --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
-- docker exec coreflow-kafka kafka-topics --create --topic payment.processed --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

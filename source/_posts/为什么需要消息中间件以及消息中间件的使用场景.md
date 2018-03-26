---
title: 为什么需要消息中间件 以及 消息中间件的使用场景
date: 2018-03-13
categories: 
- MQ
tags:
- MQ
---
## 生产者消费者模式的思考
- 如何多机器部署运行  <分布式>？
    >挑战：queue无法跨JVM共享
- 如何灾备以及负载均衡？
    >挑战：需要一个controller做通知和分发数据

- 所以，需要一个独立部署的可以被多方访问的服务，其数据必须是多线程乃至分布式安全的
    消息中间件是个好的选择
![消息总线图](/images/消息总线.jpg)

## 消息中间件的特征
- queues （消息的容器）
- 发布/订阅（Publisher/Subscribe） （发布者发布1条数据，会被多个订阅者消费）
    >将增量式更新数据推给各个订阅的client，并保证每个client都收到
    
    >将数据平均发送给每个订阅者（负载均衡，例如：RocketMQ的CLUSTERING消息模型）
- P2P（Peer-to-Peer） （1条消息只会被消费一次）
<!--more-->
## 对消息中间件的一般要求
    服务的高可用性（主从或者分布式）
    消息的低延迟、极少量丢失或不丢失

## 对消息中间件的进一步要求：
    消息不重复
    支持事务
    负载均衡

## 应用场景

### 异步
    将传统线性程序，转为并发分布式
    
* 传统线性做法：
        1. 动作一
        2. 动作二
* 利用消息中间件，并发处理。（发送一个订阅消息，然后由各个消费者并行处理）
    * consumer1：动作一 （只需保证动作一最终一定成功便可，不关心时效性）
    * consumer2：动作二

### 解耦
    在新增功能点时，无需更改主流程代码或逻辑
    
* 如果要在动作二后增加动作三，只需再增加相应的订阅者，无需更改主流程
    * consumer3：发送短信通知下单者支付成功。
* 把支付、退款从hotel移到到wfinance中统一管理

### 负载均衡
* 多个consumer分布在多个不同的机器上，热部署.如rocketMQ的集群模式
    >consumer.setMessageModel(MessageModel.CLUSTERING);

### 防治消息洪流
* 要求消息中间件有以下两个能力
    >强有力的消息堆积
    
    >持久化
* 消息队列可以作为 缓冲区域 存在
* 实例见下文的 日志收集 案例

### push数据
    场景描述：各个client每10分钟请求一次我们的API，以获取我们的增量数据

### 日志收集
1. Kafka：接收用户日志的消息队列。
Kafka可以快速接收所有收集过来的日志，并提供堆积和持久化功能，以便Logstash等后续消费者慢慢处理。
2. Logstash：做日志解析，统一成JSON输出给Elasticsearch。
3. Elasticsearch：实时日志分析服务的核心技术，一个schemaless，实时的数据存储服务，通过index组织数据，兼具强大的搜索和统计功能。
4. Kibana：基于Elasticsearch的数据可视化组件，超强的数据可视化能力是众多公司选择ELK stack的重要原因。
![日志收集架构图](/images/日志收集架构图.png)

## References :
* [系统间通信系列博文](http://blog.csdn.net/column/details/sys-communication.html)
* [RocketMQ简介及安装](http://blog.csdn.net/df_xiao/article/details/50522476)
* [消息队列的使用场景](http://www.cnblogs.com/mxmbk/articles/6598126.html)
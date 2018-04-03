---
title: RocketMQ一基本概念
date: 2018-03-14 00:21:26
categories: 
- MQ
- RocketMQ
tags:
- MQ
- RocketMQ
---
###### contents
>1. Main Concepts
>>* nameServer
>>* Broker
>>* producer
>>* consumer
>>* group
>
>2. 同步 - 异步
>3. 安装
>>* 单机
>>* 主从
>
>4. 控制台
>>1. mqadmin
>>2. 控制台(rocketMq-console)
<!--more-->
#### Main Concepts
##### nameServer
> TODO

##### broker
> TODO

##### producer
* 生产者端的负载均衡（生产者发送时，会自动轮询当前所有可发送的broker，一条消息发送成功，下次换另外一个broker发送，以达到消息平均落到所有的broker上）
    * 假如某个Broker宕机，意味生产者最长需要30秒才能感知到。在这期间会向宕机的Broker发送消息


* ProducerGroupName
  For non-transactional messages, it does not matter as long as it's unique per process.
  * nameSrv

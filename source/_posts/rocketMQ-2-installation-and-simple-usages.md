---
title: RocketMQ二安装与简单实用
date: 2018-03-14 02:21:26
categories: 
- MQ
- RocketMQ
tags:
- MQ
- RocketMQ
---

### 目录
#### 部署
 >* 1 Master
 >* 2 Master
 >* 2 Master - 2 Salve async
 >* 2 Master - 2 Salve sync            
#### 控制台安装
#### 发送消息的默认约定
#### 消费消息的默认约定
#### 并行消息(多线程多Queue)
#### 有序消息(单线程单一ueue)
#### 延迟消息(单线程单一ueue)
<!--more-->
----
### 部署
    下载并解压[rocketmq](http://mirrors.tuna.tsinghua.edu.cn/apache/incubator/rocketmq/4.0.0-incubating/rocketmq-all-4.0.0-incubating-bin-release.zip )
#### 1 Master
* 启动nameServer
    ```
    nohup sh bin/mqnamesrv &
    ```
* 启动broker
    ```
    nohup sh bin/mqbroker -n localhost:9876 -c conf/broker.conf &
    ```
* shutdown
    ```
    bin/mqshutdown broker
    bin/mqshutdown namesrv
    ```
#### 2 Master
    TODO
    
#### 2 Master - 2 Salve async
    TODO
    
#### 2 Master - 2 Salve sync

    TODO
### 控制台安装
>控制台使用apache/incubator-rocketmq-externals下的rocketmq-console
* clone：
    ```
    https://github.com/apache/incubator-rocketmq-externals.git
    ```
* 打包
    ```
    mvn clean package -Dmaven.test.skip=true
    ```
* 启动
    ```
    java -jar rocketmq-console-ng-1.0.0.jar --server.port=12581 --rocketmq.config.namesrvAddr=localhost:9876
    ```
* 访问控制台：http://localhost:12581

### 发送消息的默认约定：
* 一个JVM一个MqMessageSender实例，后续视情况是否改为prototype
* 默认发送方式为同步 - sendMsg(String, String, String, String)
* client没有必要retry
    > rocketMQ已经有retry, MqMessageSender里也会做必要的失败记录和服务不可用时的retry
    * rocketMQ的retry
        ```
        defaultSendingTimeout = 3000 mills
        retryTimesWhenSendFailed = 2
        ```
    * 如果发送失败，确保消息不丢失
    * MqMessageSender会保存消息到DB，同时抛出unCheckedException
        * （TODO）服务可用后，可以从DB中重新发送
        * 应用程序接收到Exception后，做必要处理
* producerGroup
    * 作用：
    >* 标识一类 Producer
    >* 可以通过运维工具查询这个发送消息应用下有多个 Producer 实例
    >* 发送分布式事务消息时，如果 Producer 中途意外宕机，Broker 会主动回调 Producer Group 内的任意一台机器来确认事务状态。
    
    * one producerGroup per application as default
    >* 一个 Producer Group 下包含多个 Producer 实例，可以是多台机器， 也可以是一台机器的多个进程，或者一个进程的多个 Producer 对象。
    >* 一个 Producer Group 可以发送多个 Topic 消息.

### 消费消息的默认约定：
    TODO
### 并行消息(多线程多Queue)

### 有序消息(单线程单一ueue)

### 延迟消息(单线程单一ueue)
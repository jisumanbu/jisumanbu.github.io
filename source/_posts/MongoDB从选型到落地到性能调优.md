---
title: MongoDB从选型到落地到性能调优
date: 2018-04-15 10:05:52
categories: 
- 存储
tags:
- 存储
---
#### 目标数据
  * 数据量
    > * 20万条数据，总大小5G
    > * 部分数据会达到1.5M~2M/条
  * 每条数据的内容包含：
    > * 1个基本信息 
    > * 60个dailyInfo
    > * 数据相对独立，无关联
  * 读写：
    > * 夜里有尽5个小时的全量覆盖写
    > * 增量数据更新造成的不定时随机写<QPS未知>
    > * 每小时会有一次遍历读
    > * 全天由用户正常的访问造成的随机读<QPS未知>
#### 问题描述与分析
  * 现状
    > * 数据存储在Redis中
    > * 序列化采用[fast-serialization](https://github.com/RuedigerMoeller/fast-serialization)
     FST虽然比JDK原生序列化快很多，但是运维成本很高：只要实体类稍微有变更，哪怕添加字段、空的构造函数都会造成反序列化出错。
  * 问题
    > * 有时出现"Redis server response timeout"
    > * 查询缓慢
    > * Redis占用内存偏大
  * 分析与结论
    > * 大文件不适合用Redis存储
     Redis的存储结构与单线程设计决定了它对于大文件的性能会很好。
     [Redis当value大小超过10k]()
    > * 这些数据更适合用document的NoSQL

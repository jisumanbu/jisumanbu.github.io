---
title: Redis实战（Redis IN ACTION）
date: 2018-03-15
categories: 
- readNote
tags:
- Redis
- 存储
---
#### 第1章 初识Redis
* Redis的优点
    >比关系型数据库更效率、更易用；比内存数据库有数据结构上的优势
    
    * 高性能内存数据库，但支持持久化《RDB, AOF》
    * 5种数据结构 《string, List, set, hash, zset
    * 第6种数据结构：pub/sub
    * 简单事务
    * 过期机制
    * 主从复制 -> 扩展读性能，故障转移
<!--more-->
#### 第4章 数据安全与性能保障
* 4.1 持久化选项
    >* 快照持久化<SNAPSHOT/RDB、AOF>
    >* 从服务器的复制启动过程<第一次同步>
    
    * SNAPSHOT/RDB <高效恢复数据，但是有停顿，丢数据>
        * BGSAVE
            * fork子进程 -> 停顿 <生成子进程的过程会阻塞父进程>
              >可关闭自动保存，手动触发
              
            * 内存不足时 -> 使用虚拟内存
                >master内存使用率应在50%~65%
                
        * SAVE
            * 没有子进程，故比BGSAVE快
        * 数据完整性
            * 可承受丢失多长时间的数据？
                >save 60 1000
                
            * 丢失了那些数据？ -> process_logs()
                >保证日志的处理结果和处理进度总是同时被记录到快照文件里面
                
    * AOF 
        >1. 不丢数据，无停顿，但恢复慢，日志体积大
        >2. 主从写更新
        
        * 同步频率<appendfsync选项>
            * always<每次写都触发同步，每次只写入一个命令> -> 最慢
            * everysec<每秒触发一次同步> -> 推荐
            * no<操作系统自动决定同步时机> -> 不推荐
        * 重写/压缩AOF文件
            * BGREWRITEAOF -> 工作机制同BGSAVE，停顿
            * 何时执行BGREWRITEAOF？
                * auto-aof-rewrite-percentage
                * auto-aof-rewirte-min-size
* 4.2 复制(replication)
    * 主从复制 <不支持多主复制>
    * 复制的启动过程
    * 主从链
        * 复制中间层 -> 分担主服务器的复制工作
    * 检查硬盘写入
    * conn.info()….
* 4.3 处理系统故障
    * 验证AOF文件
        >可修复
    * 验证快照文件
        >* 不可修复
        >* 恢复前需验证快照文件<SHA1/SHA256>
    * 更换故障主服务器、Redis Sentinel的故障转移
* 4.4 事务
    * watch + retry
        >如果数据被更改，收到watch的通知，然后重试
    * 流水线（pipelining）方式：pipe.multi + pipe.execute
        >一次性发送多个命令，然后等待所有回复出现<如果执行过程中，接到watchError则失败>
* 4.5 非事务型流水线
    * pipe = conn.pipeline(false)   《单纯的把多个命令打包，一起发送》
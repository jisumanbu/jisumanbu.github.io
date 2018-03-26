---
title: HTTP、HTTPS、TOKEN的比较 以及 如何选择
date: 2018-03-15
categories: 
- Web
- Security
tags:
- HTTPS
- JWT
---
### HTTP与HTTPS
* HTTP的缺点 及 解决方案
    * 通信使用明文(不加密)，内容可能被窃听
        > 加密
    * 不验证通信方的身份，因此有可能遭遇伪装（假的server或client）
        > 证书 （支持双向验证，但通常只验证服务端.）  
        > SSL客户端的身份验证是可选的，由SSL服务器决定是否验证SSL客户端的身份
    * 无法证明报文的完整性，所以有可能已遭篡改
        > 基于散列值校验（MD5 / SHA-1）等等的完整性校验方案   
* HTTPS可以完美解决以上问题
    >* **HTTP + 加密 + 认证 + 完整性保护 = HTTPS**      
    >* 请求包可以被截获，但无法解密读取
    >* 对于HTTPS不做赘述，下面仅附图一张    
    ![图解HTTPS](/images/图解HTTPS.png)
<!--more-->
* 既然HTTPS那么安全可靠，那为何所有的网站不一直使用HTTPS ？
    * HTTPS比HTTP慢2到100倍
        * 通信慢
            > TCP/IP之上还需要SSL通信
        * 消耗更多的CPU和内存
            > 客户端和服务端都必须加密解密运算，
    * 证书的开销
    
### HTTP + TOKEN：每次请请求都携带**经过加密且被签名的token**
* 无状态，可快速验证用户的有效性
* 加密，防止token被读取篡改
* 但是第三方可以用截取到的token伪造请求，所以client有被劫持的风险；签名和设置有效期可以解决
    * GET等非敏感请求
        * 设置token的有效期"per session cookies, and per request" -- 防CSRF
        * 对于GET，token的签名包含url，确保token和URL是对应的没被更改的 -- 请求顶多被窃听
            > 例如Get请求时，将parameters加入到签名里，从而防止被篡改；但仍然可以被监听.   
            POST请求则直接对请求体做MD5计算，将MD5值加入签名.
    * POST等敏感请求，用HTTPS

### 最终选择
* 首选HTTPS，如果不用考虑性能和money的话
    > 认证可随意选择，用户名密码或者简单token
* HTTP + **token**，请求体、相应体有被监听的风险
    >1. 提前约定secret、加密方式等   
    >2. 每次请求都生成唯一的经过加密和签名的token
    >3. 将md5(requestContent/parameter)作为签名的一部分，避免劫持   
        上面两点**无法防止伪装**，token可以被窃取，从而有被劫持.可以将md5(requestContent/parameter)作为签名的一部分，避免劫持，顶多有被监听的风险，因为信息不明感，从而可忽略
* HTTP和HTTPS组合使用
    * 非敏感信息使用HTTP + **token**的认证方式
    * 只有在接触敏感信息时才使用HTTPS，如登录

### 反推TOKEN的特性
* 加密，不可被窃听
    >1. 加密方式
    >2. 秘钥
    >3. 对于API，一般不要求登录，所以用户名和密钥要提前约定好.
* 签名，可以证明请求没有没篡改
* 有效期设置功能，防止被窃取后伪造请求；如果是浏览器访问也可以解决CSRF
    * “**per session cookies, and per request tokens**.”， 可以解决CSRF，但不能解决监听问题。
    * API不存在CSRF问题，但如果token永不过期，截取到token便可以伪造请求了，所以可以为API的token设置一个长点的过期时间
    * 所以建议：
        * API
            >* 非敏感数据的API过期设的长一些，以免让client频繁请求token
            >* 敏感数据直接升级用HTTPS
        * B/S
            >* HTTPS + per request token

### 案例
* 去哪儿，HTTP+TOKEN 和 HTTPS
    * 非敏感数据采用 HTTP + TOKEN
        ``` java
        String sign = DigestUtils.md5Hex(DigestUtils.md5Hex(secretKey + appKey) + salt);
        ```
        > appKey、secretKey提前约定好   
        没有有效期，截取sign后可以长期伪装client, 发送重复请求。   
        没有签名， 伪装client，且可以更改请求
    
* 亮哥，HTTP + TOKEN
    ``` java
    String sign = md5(userId + timestamps + secret);//per request timestamps
    ```
    > server端记录每次请求的timestamps, 当次有效   
    没有签名， 可以被劫持，从而更改请求
    
    
    

### 伪装问题
* HTTPS不存在伪装问题
    >1. 有证书保证server身份，所以无法伪装server   
    >2. 在用户名密码不被泄露的情况下，能建立起SSL的就是真正的用户
* HTTP虽然无法彻底解决伪装问题，但是因为token的不可更改不可窃听的属性，伪装被降级成转发监听
    > 由于token是不可读，不可修改的，所以第三方无法伪造只能引用.   
    又因为加了有效期，所以第三方最多只能转发监听

#### Client-side/Stateless Sessions (客户端持有的/无状态session)
* stateless
    >只保存客户数据  
    
* JWT不可被第三方 读取 和 更改
    >签名 = 不可更改  
    加密 = 不可读
    
#### Cross-Site Request Forgery (CSRF - 跨站请求伪造)
* 由于同一浏览器进程下 Cookie 可见性，导致用户身份被盗用，完成恶意网站脚本中指定的操作

* 解决方案
    > “**per session cookies, and per request tokens**.”  
    
* 案例一
    1. 客户端每个request都必须携带 userId + **timestamps** + token
        > token = md5(userId + secret + timestamps**)，确保信息不被更改
    2. timestamps只能使用一次
        > 服务端先校验timestamps是否已经被处理，如果已经处理，拒绝请求
    3. 服务端根据收到的userId + timestamps和约定好的secret计算token，然后和收到的token进行比较校验
    
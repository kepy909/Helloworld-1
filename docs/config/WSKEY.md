# :fa-regular fa-database: WSKEY
- WSKEY 是**移动端APP**特有的值，使用以后再也不用月月喊人更新账号了，本项目拥有最新版本且全网最稳定的转换脚本

> [!ATTENTION]
> **注销登录**（在抓取WSKEY设备的APP中手动操作退出账号登录）、**修改密码**会导致其失效\
> 若想在APP中切换账号直接卸载APP即可，极少数情况下存在被官方主动踢下线的可能性

> 目前 WSKEY 的有效期为半年，配置后可转换生成有效期为 `24` 个小时的 `pt_key`

> [!WARNING|label:声明]
> 转换脚本是本项目中唯一的加密脚本位于 **utils/UpdateCookie.js**，为了防止被滥用已局部加密关于**获取签名**部分的代码\
> 该转换脚本为**本地转换**，没有加密转换部分的代码，其它任何通过在线获取签名的转换脚本均存在账号泄露的风险\
> 作者承诺该脚本乃至整个项目均没有任何上传行为，可自行抓包验证随时接受检验，我们始终保留对造谣者追究的权利

- 目前推荐定时设置
  > 项目已配置定时任务但默认被注释，如需使用请自行取消注释

  ```cron
  <自定义分钟> 1,9,17 * * * sleep $((${RANDOM} % 56)) && task cookie update >/dev/null 2>&1
  ```
  > [!TIP]
  > 更新频率由您的账号数量决定，目前建议每天更新 `三` 次即每 `8` 小时更新一次

  > [!ATTENTION]
  > 应合理规划该脚本的定时，部分脚本执行时间过长可能导致ck在执行期间过期失效，应在这类脚本执行前进行更新，尤其号多者

## 配置方法

> [!NOTE|label:面板入口]
> 编辑配置 - 账号配置

?> 1. 建议通过面板进行编辑，有格式检测可以减少配置出错\
  2. 注意 `pt_pin` 和 `ws_key` 填入的是对应的值，不要把格式和标点符号带进去

- 编辑位于 **config** 目录下的 **account.json** 配置文件

  ```json
  [
    {
      "pt_pin": "user_α",
      "ws_key": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "remarks": "阿尔法",
      "config": {
        "ep": {}
      }
    },
    {
      "pt_pin": "user_β",
      "ws_key": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "remarks": "贝塔",
      "config": {
        "ep": {}
      }
    },
    {
      "pt_pin": "",
      "ws_key": "",
      "remarks": "",
      "config": {
        "ep": {}
      }
    }
  ]
  ```

  > [!NOTE]
  > `remarks` 是通知备注，会在适配脚本的推送消息中将用户名昵称换成备注名称
  >
  > `ep` 是设备信息，对于目前来说可填可不填没有实际意义，一般出现在请求的 **Body** 中
  >
  > `pt_pin` 是用户名，目前在APP的部分请求中已被加密可能无法通过抓包有效获取，可前往账号设置进行查看\
  > 如果用户名含有中文汉字需转换成 `UrlEncode`，面板自带转换工具，入口：`账号配置 - URL编码/解码`

***

## 协助抓取
> 此方法**旨在为帮助他人抓取WSKEY**，需要一台有**公网IP**的 Linux 环境，基于 [AnyProxy - 由阿里巴巴集团发布的一款开源抓包工具](https://github.com/alibaba/anyproxy)\
> 如果是本地操作借助一些专业工具即可无需使用此方法，例如安卓：Httpcanary；IOS：Stream、Thor 等App

- ### 安装 Nodejs 和 npm 环境 <!-- {docsify-ignore} -->

  > 如果已安装则忽略该步骤

  - 安装 Nodejs

    ```bash
    curl -sL https://deb.nodesource.com/setup_16.x | bash -
    ```
    > 由于 NodeSource 没有国内源，下载速度可能较慢

    ```bash
    apt-get install -y nodejs 或 yum install -y nodejs
    ```
    > 根据自己的操作系统使用对应包管理工具进行安装，该命令会附带安装 **npm**
  
  - npm 切换国内源

    ```bash
    npm config set registry https://registry.npm.taobao.org
    ```
    > 如果没有国际互联网环境建议切换为国内淘宝源

- ### 安装并配置 AnyProxy <!-- {docsify-ignore} -->

  - 安装

    ```bash
    npm install -g anyproxy
    ```

  - 生成证书

    ```bash
    anyproxy-ca
    ```
    > 一路回车

  - 启动服务

    ```bash
    anyproxy --intercept
    ```
    > `Ctrl + C` 停止运行，由于[解析了所有 https 请求](http://anyproxy.io/cn/#%E4%BB%A3%E7%90%86https)，存在服务报错中断的情况，同时设备连接代理后网络会变慢请耐心等待加载完毕

- ### 使用方法 <!-- {docsify-ignore} -->

  - #### 客户端（对方）操作 <!-- {docsify-ignore} -->

    > [!TIP]
    > 一共三步，请认真阅读自己设备对应操作系统的教程
    
    - ##### 1. 安装证书

      !> 用手机自带的或已安装的浏览器APP打开不要通过微信，iOS统一用Safari

      ?> 系统浏览器打开 [http://\<ip\>:8002](http://<ip>:8002 ':disabled') 左侧 RootCA - Download 下载证书文件，如果出现让你选择文件则选择第一个 `rootCA.crt`

      - ###### iOS/iPadOS：下载后弹窗点击允许，如果没有自动弹窗那么就从下载历史里点一下，然后打开系统设置 - 已下载描述文件 - 安装，安装完成后转到通用 - 关于本机 - 证书信任设置 - 针对根证书启用完全信任 - 启用 AnyProxy
      - ###### Android：从本地文件管理或浏览器下载记录中点击已下载的证书文件，会自动弹出系统自带的证书安装器（可能会让你选择打开程序方式），填写名称为 AnyProxy 或随便起个，类型保持默认选择用于Wi-Fi
    
    - ##### 2. 配置代理

      - ###### iOS/iPadOS：系统设置 - 无线局域网 - 已连接Wi-Fi右边感叹号 - 下划至底部配置代理 - 选择手动
      - ###### Android：系统设置 - WLAN - 长按已连接的Wi-Fi进入配置找到配置代理选项（各品牌OS界面不同自行判断） - 选择手动

      > [!NOTE|label:具体配置内容]
      > 主机名：`<ip>`\
      > 端口：`8001`\
      > 没有用户名和密码

      > 通过专业软件连接代理也是可以的，运营商网络也支持配置代理，不过最方便的还是通过Wi-Fi连接，因为对方不一定懂这些

    - ##### 3. 打开JD APP

      > 如果之前打开过则需要从后台关掉重新打开一个新的，如果前两步操作正确APP会正常联网否则就加载不出来内容，然后点击 **我的** 随便划一划等待加载出用户信息

  - #### 服务提供者（你）操作 <!-- {docsify-ignore} -->

    > 打开 [http://\<ip\>:8002](http://<ip>:8002 ':disabled') 进入 AnyProxy 面板查看关于 `api.m.jd.com` 域名链接特别长的 **POST** 请求，`wskey`会出现在 **Cookies** 中

    > 抓到后联系对方关闭代理即可，证书删不删无所谓，部分安卓手机可能会出现关于安装第三方证书的网络警告

    ?> 面板有内容说明代理连接正常，如果请求中没有 `Header` 内容或者客户端断网说明证书安装异常，已知某为手机容易出现APP断网的情况原因暂时未知

# WSKEY
> 配置后可转换生成有效期为 `16` 个小时的 `pt_key` ，非常稳定，用了以后再也不用月月喊人更新账号了\
> WSKEY是移动端APP特有的值，有效期为1年相当于永久，注意手动注销、修改密码会导致其失效\
> 项目已配置定时任务但默认被注释，如需使用自行取消注释，每天更新3次较为稳妥

> 转换脚本位于 **utils/UpdateCookie.js**，是本项目中唯一的加密脚本\
> 为了防止该脚本被滥用已对其中关于**获取签名**部分的代码进行了局部加密\
> 作者郑重承诺该脚本没有任何上传行为，可以自行抓包验证，随时接受检验

- 配置示例

?> 1. 建议通过面板中的 `编辑配置 - 账号配置` 进行编辑，有格式检测防止配置出错\
  2. 注意 `pt_pin` 和 `ws_key` 填入的是对应的值，不要把格式和标点符号带进去

```json
[
  {
    "pt_pin": "jd_1234567",
    "ws_key": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "remarks": "张三",
    "config": {
      "ep": {}
    }
  },
  {
    "pt_pin": "jd_abcdefg",
    "ws_key": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "remarks": "李四",
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

> `remarks` 是通知备注，会在适配脚本的推送消息中将用户名昵称换成备注名称\
> `ep` 是设备信息，对于目前来说可填可不填

> `pt_pin` 是用户名，目前在APP中已被加密无法通过抓包直接获取\
> 如果用户名含有中文汉字需转换成 `UrlEncode`，面板自带转换工具，入口：`账号配置 - URL编码/解码`

> 后续会完善关于 `ws_key` 的抓取教程
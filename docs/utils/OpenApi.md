# 控制面板开放应用程序接口

## 一、API 接口说明

  - 接口基准地址：`http://127.0.0.1:5678/openApi`
  - 服务端已开启 CORS 跨域支持
  - API认证统一使用 Token 认证
  - 使用 HTTP Status Code 标识状态
  - 数据返回格式统一使用 JSON
  - 需要授权的 API ，必须在请求头中使用 `api-token` 字段提供 `openApiToken`的值

    - 获取 `openApiToken` 的方法

      ```bash
      taskctl panel info | grep ApiToken
      ```
      > [!ATTENTION]
      > 最新版本已将 `cookieApiToken` 更名为 `openApiToken`，如仍显示旧版名称则需要在控制面板修改登录认证信息以重置此Token

- ### 1. 支持的请求方法

  - `GET（SELECT）`：从服务器取出资源（一项或多项）
  - `POST（CREATE）`：在服务器新建一个资源
  - `PUT（UPDATE）`：在服务器更新资源（客户端提供改变后的完整资源）
  - `PATCH（UPDATE）`：在服务器更新资源（客户端提供改变的属性）
  - `DELETE（DELETE）`：从服务器删除资源
  - `HEAD`：获取资源的元数据
  - `OPTIONS`：获取信息，关于资源的哪些属性是客户端可以改变的

- ### 2. 通用返回状态说明

  | *状态码* |         *含义*         | *说明*                                        |
  | :-----: | :-------------------: | --------------------------------------------- |
  |  `200`  |          OK           | 请求成功                                       |
  |  `201`  |        CREATED        | 创建成功                                       |
  |  `204`  |        DELETED        | 删除成功                                       |
  |  `400`  |      BAD REQUEST      | 请求的地址不存在或者包含不支持的参数                |
  |  `401`  |      UNAUTHORIZED     | 未授权                                         |
  |  `403`  |       FORBIDDEN       | 被禁止访问                                      |
  |  `404`  |       NOT FOUND       | 请求的资源不存在                                 |
  |  `422`  |  Unprocesable entity  | [POST/PUT/PATCH] 当创建一个对象时，发生一个验证错误 |
  |  `500`  | INTERNAL SERVER ERROR | 内部错误                                       |

- ### 3.业务代码说明

  |    *状态码*   |     *含义*      | *说明*  |
  | :----------: | :------------: | ------- |
  |      `0`     | fail           | 请求错误 |
  |      `1`     | success        | 请求成功 |
  | `403`/`4403` | openApi 认证失败 |        |

- ### 4. 通用返回内容

  | 参数名 | 参数说明 |
  | :---: | :-----: |
  | code  | 业务代码 |
  | data  | 返回结果 |
  | msg   | 结果消息 |
  | desc  | 结果描述 |

***

## 二、内置接口

- ### 1. 添加/更新账号

  - #### 普通Cookie

    - 请求路径：`updateCookie`
    - 请求方法：`POST`

    - 请求参数

      |  参数名  |   参数说明   |   备注   |
      | :-----: | :---------: | :-----: |
      | cookie  | 完整cookie值 | 不能为空 |
      | userMsg |     备注     | 可以为空 |

    - 响应数据示例

      ```json
      {
        code: 1,
        data: 1,
        msg: "success"
      }
      ```
      > [!NOTE|label:参数说明]
      > `msg:`：结果消息\
      > `code`：业务代码中的状态码\
      > `data`：表示 Cookie 数量（正整数）

  - #### WSKEY & Cookie二合一

    - 请求路径：`addOrUpdateAccount`
    - 请求方法：`POST`

    - 请求参数

      |  参数名  |  参数说明  |   备注   |
      | :-----: | :-------: | :-----: |
      |  ptPin  | pt_pin的值 | 不能为空 |
      |  ptKey  | pt_key的值 | 可以为空，如果为空则不更新 |
      |  wsKey  | ws_key的值 | 不能为空 |
      | remarks |  备注内容   | 可以为空，默认为`ptPin`的值 |

    - 响应数据示例

      ```json
      {
          code: 1,
          data: {
              cookieCount: 1,
              accountCount: 1
          },
          msg: ""
      }
      ```
      > [!NOTE|label:参数说明]
      > `msg:`：结果消息\
      > `code`：业务代码中的状态码\
      > `data`：**cookieCount** 表示 Cookie 数量（正整数）\
      >ㅤㅤㅤㅤ **accountCount** 表示 WSKEY 数量（正整数）

- ### 2. 删除账号

  - 请求路径：`cookie/delete`
  - 请求方法：`POST`
  - 请求参数：

    |  参数名  |       参数说明       |         备注          |
    | :-----: | :-----------------: | :------------------: |
    | ptPins  | 由pt_pin的值组成的数组 | 例 `["pin1","pin2"]` |

  - 响应数据示例：

    ```json
    {
        code: 1,
        data: {
            cookieCount: 1,
            accountCount: 1,
            deleteCount: 1
        },
        msg: ""
    }
    ```
    > [!NOTE|label:参数说明]
    > `msg:`：结果消息\
    > `code`：业务代码中的状态码\
    > `data`：**cookieCount** 表示 Cookie 数量（正整数）\
    >ㅤㅤㅤㅤ **accountCount** 表示 WSKEY 数量（正整数）\
    >ㅤㅤㅤㅤ **deleteCount** 表示此次删除的 Cookie 数量

- ### 3. 统计账号数量

  - 请求路径：`count`
  - 请求方法：`GET`

  - 响应数据示例：

    ```json
    {
        code: 1,
        data: {
            "cookieCount": 1,
            "accountCount": 1
        },
        msg: ""
    }
    ```
    > [!NOTE|label:参数说明]
    > `msg:`：结果消息\
    > `code`：业务代码中的状态码\
    > `data`：**cookieCount** 表示 Cookie 数量（正整数）\
    >ㅤㅤㅤㅤ **accountCount** 表示 WSKEY 数量（正整数）

- ### 4. 修改账号排序

  - 请求路径：`account/sort`
  - 请求方法：`POST`
  - 请求参数：

    |  参数名  |      参数说明       |
    | :-----: | :----------------: |
    |  ptPin  |      pt_pin的值     |
    |  sort   | 新的账号序号（正整数） |

  - 响应数据示例：

    ```json
    {
        code: 1,
        data: {
            "cookieCount": 1,
            "accountCount": 1
        },
        msg: ""
    }
    ```
    > [!NOTE|label:参数说明]
    > `msg:`：结果消息\
    > `code`：业务代码中的状态码\
    > `data`：**cookieCount** 表示 Cookie 数量（正整数）\
    >ㅤㅤㅤㅤ **accountCount** 表示 WSKEY 数量（正整数）

***

## 三、用户自定义接口

> [!NOTE|label:使用方法]
> 将您的 **Api** 脚本以 `extra_server.js` 命名并存放在 **config** 目录下，重启面板后生效

  - 可以参考下方的简单示例
    
    <div style='color: var(--themeColor);'>
    <details>

    <summary>点击此处展开代码 👈</summary>

    ```javascript
    var path = require('path');
    var fs = require('fs');

    var rootPath = process.env.JD_DIR;
    // 到家果园日志文件夹
    var jddjFruitLogDir = path.join(rootPath, 'log/jddj_fruit/');

    /**
     * 获取文件内容
     * @param fileName 文件路径
     * @returns {string}
     */
     function getFileContentByName(fileName) {
      if (fs.existsSync(fileName)) {
        return fs.readFileSync(fileName, 'utf8');
      }
      return '';
    }

    /**
     * 获取目录中最后修改的文件的路径
     * @param dir 目录路径
     * @returns {string} 最新文件路径
     */
    function getLastModifyFilePath(dir) {
      var filePath = '';

      if (fs.existsSync(dir)) {
        var lastmtime = 0;

        var arr = fs.readdirSync(dir);

        arr.forEach(function (item) {
          var fullpath = path.join(dir, item);
          var stats = fs.statSync(fullpath);
          if (stats.isFile()) {
            if (stats.mtimeMs >= lastmtime) {
              filePath = fullpath;
            }
          }
        });
      }
      return filePath;
    }

    // 获取到家果园互助码列表
    function getJddjFruitCodes() {
      const lastLogPath = getLastModifyFilePath(jddjFruitLogDir);
      const lastLogContent = getFileContentByName(lastLogPath);
      const lastLogContentArr = lastLogContent.split('\n');
      const shareCodeLineArr = lastLogContentArr.filter(item => item.match(/到家果园互助码:JD_/g));
      console.log(shareCodeLineArr);
      const shareCodeStr = shareCodeLineArr[0] || '';
      const shareCodeArr = shareCodeStr.replace(/到家果园互助码:/, '').split(',').filter(code => code.includes('JD_'));
      return shareCodeArr;
    }

    // 生成到家果园互助码文本
    function createJddjFruitCodeTxt(page, size) {
      const shareCodeArr = getJddjFruitCodes();
      if (shareCodeArr.length > size * (page -1)) {
        const filtered = shareCodeArr.filter((code, index) => index + 1 > size * (page - 1) && index + 1 <= size * page);
        return filtered.join(',');
      }
      return '';
    }

    function diyServer(app) {
      /**
       * 获取到家果园互助码
       */
      app.get('/api/sharecode/jddj_fruit', function(req, res) {
        const page = req.query.page || '1';
        const size = req.query.size || '5';
        const content = createJddjFruitCodeTxt(Number(page), Number(size));
        console.log(`到家果园互助码: ${content}`);
        res.setHeader("Content-Type", "text/plain");
        res.send(content);
      });
    }
    
    module.exports = diyServer;
    ```

    </details>
    </div>
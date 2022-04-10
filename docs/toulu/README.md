> [!ATTENTION]
> 仅供内部使用，如有发现内鬼立即关闭并停止支持相关脚本

## 工具脚本库

  ```bash
  task repo git@jd_base_gitee:SuperManito/touluyyds.git master
  ```

## 屏蔽账号（超级无线）

  ```bash
  case $1 in
  ## 通用
  jd_lzclient | jd_wxShopFollowActivity | jd_dadoudou | jd_share | m_jd_wx_luckDraw | m_jd_wx_collectCard | m_jd_wx_addCart)
    TempBlockCookie="" ## 屏蔽黑号
    ;;
  ## 加购建议根据情况自定义
  jd_wxCollectionActivity | m_jd_wx_addCart)
    TempBlockCookie="" ## 加购有礼屏蔽黑号和不跑的号
    ;;
  esac
  ```

***

- ## 一键入会领豆

  ?> 最新版本：2.1\
    更新日期：2022-04-07

  > 默认**最低入会限制为 `10` 🐶** ，如想修改这些默认设置请直接修改脚本内置变量

  - ### 安装方法

    - 拉取脚本并存放在 **config** 目录下

      ```bash
      wget --no-check-certificate https://supermanito.github.io/Helloworld/toulu/rh/ruhui.sh -O ${WORK_DIR}/config/ruhui.sh
      ```

    - 赋予可执行权限

      ```bash
      chmod 777 ${WORK_DIR}/config/ruhui.sh
      ```

    - 添加软链接

      ```bash
      ln -sf ${WORK_DIR}/config/ruhui.sh /usr/local/bin/rh
      ```
      > 也可以将 `rh` 修改成你想叫的名字

  - ### 更新方法

    - 执行安装方法的前二步

  - ### 使用方法

    ```bash
    rh "店铺链接或店铺venderId的值"
    ```
    > 每次运行仅支持入会单个店铺

- ## 瓜分豆车智能组队

  ?> 最新版本：2.3\
    更新日期：2022-04-07

  > [!WARNING|label:脚本已加密]
  > 为什么要加密？因为外面搬/偷脚本的 🐶 &nbsp;太多。怕偷ck者别用！\
  > 此脚本涉及相关接口、自动分组算法等，技术含量较高不宜公开

  - ### 安装方法

    - 拉取脚本并存放在 **config** 目录下

      ```bash
      wget --no-check-certificate https://supermanito.github.io/Helloworld/toulu/zd/$(arch)/zudui.sh.x -O ${WORK_DIR}/config/zudui.sh.x
      ```

    - 赋予可执行权限

      ```bash
      chmod 777 ${WORK_DIR}/config/zudui.sh.x
      ```

    - 添加软链接

      ```bash
      ln -sf ${WORK_DIR}/config/zudui.sh.x /usr/local/bin/zd
      ```
      > 也可以将 `zd` 修改成你想叫的名字

    - 拉取脚本库（已拉者忽略）

      ```bash
      task repo https://gitee.com/SuperManito/scripts.git master
      ```

  - ### 更新方法

    - 删除旧版

      ```bash
      rm -rf /usr/local/bin/zd ${WORK_DIR}/config/zudui.sh.x
      ```

    - 执行安装方法的前三步

  - ### 配置方法

    > [!NOTE|label:自动分组机制]
    > 脚本会根据获取到的活动规则通过算法自动为本地账号分配分组运行参数，车头为头部账号并依次递增
  
    ?> 一般情况下配置账号屏蔽变量即可无需自定义分组配置，不屏蔽黑号则会占位置导致成员未满无法瓜分奖励

    > [!NOTE|label:关于变量名称]
    > 变量中含有 `LZKJ` 表示关于活动域名 [https://lzkjdz-isv.isvjcloud.com](https://lzkjdz-isv.isvjcloud.com ':disabled') 的组队配置\
    > 变量中含有 `CJHY` 表示关于活动域名 [https://cjhydz-isv.isvjcloud.com](https://cjhydz-isv.isvjcloud.com ':disabled') 的组队配置

    - 账号屏蔽（重要）

      ```bash
      LZKJ_ZD_BLOCK=""
      CJHY_ZD_BLOCK=""
      ```
      > 此变量仅在自动分组时生效，需填账号序号，多个用**空格**分开

    - 自定义组队配置（可选）

      ?> 注意区分变量名称对应的活动域名，仅在对应域名时生效

      > [!NOTE|label:详细说明]
      > 标准配置是根据变量号后面的数字决定不同可组队伍数量模式的运行配置，配置时应跳过黑号\
      > 通用配置是当在获取活动规则中的任意环节出错并再尝试多次无果时启用的配置，应设置较大的范围\
      > 变量的值与[指定账号参数](https://supermanito.github.io/Helloworld/#/use/执行脚本?id=关于指定账号相关参数的用法示例)用法相同，组与组之间用 `|` 分开而不是 `@`，可自定义多个模式下的配置

      > [!TIP]
      > 自定义组队配置逻辑性较强，并且需要在运行第2组时带上大号，如果数不清一共多少号就掰手指头\
      > 每队需要队长外加 `4` 名成员，根据不同活动单用户每次可以组 1～10 个队不等，即构成每组

      - 标准配置

        ```bash
        LZKJ_ZD_TEAM<num>=""
        CJHY_ZD_TEAM<num>=""
        ```
        > `<num>` 为队伍数量（正整数），代表对应分组模式，认真思考并理解下面的示例配置

        - 示例

          ```bash
          LZKJ_ZD_TEAM5="1-%|2,1,3-%"
          ```
          > 关于 `lzkj` 活动域名的 5 队模式配置，将运行两组账号，第一组为 `1-%`，第二组为 `2,1,3-%`

      - 通用配置

        ```bash
        LZKJ_ZD_TEAM_UNIVERSAL=""
        CJHY_ZD_TEAM_UNIVERSAL=""
        ```
        > 在获取活动规则失败后运行的配置，当用户未自定义此通用配置时将启用默认的固定配置 `1-%|2,1,3-%`

    - 检测活动火爆功能（可选）

      > 检测脚本运行记录，若存在火爆则尝试重新执行\
      > 仅限 [https://cjhydz-isv.isvjcloud.com](https://cjhydz-isv.isvjcloud.com ':disabled') 域名的活动\
      > 还支持检测活动是否结束、活动队伍已满等情况并自动跳出

      ```bash
      ZD_AUTO_RETRY=""
      ```
      > 默认已启用该功能，如需关闭请赋值为 `False`

      ```bash
      ZD_AUTO_RETRY_TIMES=""
      ```
      > 重试次数，变量的值需填正整数，注意次数越多从而频率越高容易导致IP短时间被黑，不定义此变量则默认为1次

    - 只跑豆车（可选）

      ```bash
      ZD_ONLY_BEANS=""
      ```
      > 即只跑奖品是豆子的活动，其它例如积分车则不运行，默认已关闭该功能，如需启用请赋值为 `True`

    - 一切只为了自己（可选）

      ```bash
      ZD_ONLY_LEADER=""
      ```
      > 只满足自己号的最高得豆，即只跑第一组车加第二组的第一队，默认已关闭该功能，如需启用请赋值为 `True`

    - 运行一组后的休息时长（可选）

      ```bash
      ZD_WAIT_TIMES=""
      ```
      > 具体值请参照 [sleep](https://www.runoob.com/linux/linux-comm-sleep.html) 命令的用法，直接填数字代表秒，默认已关闭该功能，如需启用请赋值

  - ### 使用方法

    ```bash
    zd "活动链接"
    ```

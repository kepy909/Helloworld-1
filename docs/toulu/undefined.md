# 偷撸

!> 如有发现内鬼将立即关闭并停止支持相关脚本，所有资源仅开放给内部用户使用！

ㅤ

***

## 主要配置

  - ### 拉取脚本库

    ```bash
    bash -c "$(printf "dGFzayByZXBvIGdpdEBqZF9iYXNlX2dpdGVlOlN1cGVyTWFuaXRvL3RvdWx1eXlkcy5naXQgbWFz\ndGVyCg==" | base64 -d)"
    ```
    > [!WARNING|label:郑重声明]
    > 禁止任何人泄漏本仓库脚本以及当前文档内容，包括但不限于强制同步、搬运等操作，否则江湖再见！

  - ### 屏蔽账号

    ```bash
    case $1 in
    jd_lzclient | jd_dadoudou | jd_share | jd_wxShopFollowActivity | jd_wxCollectCard | jd_wxSecond | jd_wxUnPackingActivity | jd_jinggengjcq_dapainew_tool)
      TempBlockCookie="" ## 屏蔽黑号
      ;;
    m_jd_wx_addCart | jd_wxCartKoi | jd_drawCenter)
      TempBlockCookie="" ## 加购相关活动屏蔽黑号和不跑的号
      ;;
    esac
    ```
    > 黑号参与活动时会提示火爆（去买买买），获取不到用户 `pin` ( getMyPing 接口)

  - ### M系列脚本控制变量

    - #### 运行账号

      ```bash
      export M_WX_WHITELIST=""
      ```
      > 默认仅运行前 **5** 个账号即 `1-5`，如想运行更多账号请赋值为 `1-<账号数量>`，可以设置一个不存在的数

    - #### 推送通知

      ```bash
      export M_WX_SENDNOTIFYON=""
      ```
      > 默认推送，如想不推送请赋值为 `false`

ㅤ

***

## 辅助一键脚本


- ### 店铺入会

  ?> Version: 2.4\
    Update: 2022-06-18

  > 默认**最低入会限制为 `10` 🐶** ，如想更改此设置请修改脚本内置变量

  - #### 安装方法

    - ##### 拉取脚本并存放在 **config** 目录下

      ```bash
      wget --no-check-certificate https://supermanito.github.io/Helloworld/toulu/rh/ruhui.sh -O ${WORK_DIR}/config/ruhui.sh
      ```

    - ##### 赋予可执行权限

      ```bash
      chmod 777 ${WORK_DIR}/config/ruhui.sh
      ```

    - ##### 添加软链接

      ```bash
      ln -sf ${WORK_DIR}/config/ruhui.sh /usr/local/bin/rh
      ```
      > 也可以将 `rh` 修改成你想叫的名字

  - #### 更新方法

    - ##### 执行安装方法的前二步

  - #### 使用方法

    ```bash
    rh <店铺链接或店铺ID的值>
    ```
    > [!NOTE|label:注释]
    > 店铺ID所代表的链接参数为 `venderId` 或 `vendorId`，支持同时入会多个店铺（变量值用 `@` 分开）\
    > 店铺链接仅支持单个店铺，如果链接中存在 `&` 符号则需要在链接的两侧加上引号以表示整体\
    > 支持部分扩展用法，通过可选命令参数实现，大致与项目主命令用法相同，详见下方

    |        参数        |  简写  |             作用             |
    | :---------------: | :----: | :-------------------------: |
    |   `--force`       |  `-f`  |  强制入会，不判断是否送豆       |
    |   `--cookie`      |  `-c`  |  指定账号，参数后需跟账号序号    |
    |   `--background`  |  `-b`  |  后台运行脚本，不在前台输出日志  |


- ### 组队瓜分奖品

  ?> Version: 2.5.0\
    Update: 2022-06-23

  > [!WARNING|label:加密脚本]
  > 怕偷ck者别用，此脚本涉及相关接口、自动分组算法等，技术含量较高不宜公开

  - #### 安装方法

    - ##### 拉取脚本并存放在 **config** 目录下

      ```bash
      wget --no-check-certificate https://supermanito.github.io/Helloworld/toulu/zd/$(arch)/zudui.sh.x -O ${WORK_DIR}/config/zudui.sh.x
      ```

    - ##### 赋予可执行权限

      ```bash
      chmod 777 ${WORK_DIR}/config/zudui.sh.x
      ```

    - ##### 添加软链接

      ```bash
      ln -sf ${WORK_DIR}/config/zudui.sh.x /usr/local/bin/zd
      ```
      > 也可以将 `zd` 修改成你想叫的名字

  - #### 更新方法

    - ##### 执行安装方法的前二步

  - #### 配置方法

    > [!NOTE|label:自动分组机制]
    > 脚本会根据获取到的活动规则通过算法自动为本地账号分配分组运行参数，车头为头部账号并依次递增
  
    ?> 一般情况下配置账号屏蔽变量即可，无需自定义分组配置，黑号会占位置需要将其屏蔽，否则队伍成员以及队长无法获得奖励

    > [!NOTE|label:关于变量名称]
    > 变量中含有 `LZKJ` 表示关于活动域名为 [https://lzkjdz-isv.isvjcloud.com](https://lzkjdz-isv.isvjcloud.com ':disabled') 的组队配置，对应脚本为 `jd_zdjr.js`\
    > 变量中含有 `CJHY` 表示关于活动域名为 [https://cjhydz-isv.isvjcloud.com](https://cjhydz-isv.isvjcloud.com ':disabled') 的组队配置，对应脚本为 `jd_cjzdgf.js`

    - ##### 账号屏蔽（重要）

      ```bash
      LZKJ_ZD_BLOCK=""
      CJHY_ZD_BLOCK=""
      ```
      > 此变量仅在自动分组时生效，需填账号序号，多个用**空格**分开，注意黑号（提示去买买买）仅针对 lzkj 域名的活动

      ?> 注意区分变量名称对应的活动域名，仅在对应活动域名时生效

    - ##### 自定义组队配置（可选）

      > [!NOTE|label:详细说明]
      > 标准配置是根据变量号后面的数字决定不同可组队伍数量模式的运行配置，配置时应跳过黑号\
      > 通用配置是当在获取活动规则中的任意环节出错并再尝试多次无果时启用的配置，应设置较大的范围\
      > 变量的值与[指定账号参数](https://supermanito.github.io/Helloworld/#/use/执行脚本?id=关于指定账号相关参数的用法示例)用法相同，但组与组之间用 `|` 分开而不是 `@`，可自定义多个模式下的配置

      > [!TIP]
      > 自定义组队配置逻辑性较强，并且需要在运行第2组时带上大号，如果数不清一共需要多少号才能跑慢建议掰手指头\
      > 每队需要队长外加 `4` 名成员，根据不同活动规则单用户每次可以组 1～10 个队不等，即构成所谓的每组

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

    - ##### 检测活动火爆功能（可选）

      > 检测脚本运行记录，若存在火爆则尝试重新执行\
      > 还支持检测活动是否结束、活动队伍已满等情况并自动跳出

      ```bash
      ZD_AUTO_RETRY=""
      ```
      > 默认已启用该功能，如需关闭请赋值为 `False`

      ```bash
      ZD_AUTO_RETRY_TIMES=""
      ```
      > 重试次数，变量的值需填正整数，注意次数越多从而频率越高容易导致IP短时间被黑，不定义此变量则默认为1次

    - ##### 只跑豆车（可选）

      ```bash
      ZD_ONLY_BEANS=""
      ```
      > 即只跑奖品是豆子的活动，其它例如积分车则不运行，默认已关闭该功能，如需启用请赋值为 `True`

    - ##### 一切只为了自己（可选）

      ```bash
      ZD_ONLY_LEADER=""
      ```
      > 只满足自己号的最高得豆，即只跑第一组车加第二组的第一队，默认已关闭该功能，如需启用请赋值为 `True`

    - ##### 运行一组后的休息时长（可选）

      ```bash
      ZD_WAIT_TIMES=""
      ```
      > 具体值请参照 [sleep](https://www.runoob.com/linux/linux-comm-sleep.html) 命令的用法，直接填数字代表秒，默认已关闭该功能，如需启用请赋值

    - ##### 监控队列模式（可选）

      ```bash
      ZD_MONITOR_MODE=""
      ```
      > 不会重复运行同一活动ID，监控队列依次运行，如需启用请赋值为  `True`

    - ##### 定时模式等待运行时长（可选）

      ```bash
      ZD_MONITOR_MODE=""
      ```
      > 针对尚未开始的活动如果小于一定时间就进入等待运行队列而非直接退出（默认300秒），如需更改此范围值请赋值为 `正整数（单位：秒）`

  - #### 使用方法

    ```bash
    zd <活动链接>
    ```
    ?> 如果链接中存在 `&` 符号则需要在链接的两侧加上引号以表示整体


- ### 联合组队瓜分奖品（微定制）

  ?> Version: 1.0\
    Update: 2022-05-24

  > 后台开卡，脚本直接组队

  - #### 安装方法

    - ##### 拉取脚本并存放在 **config** 目录下

      ```bash
      wget --no-check-certificate https://supermanito.github.io/Helloworld/toulu/wdz/wdz.sh -O ${WORK_DIR}/config/wdz.sh
      ```

    - ##### 赋予可执行权限

      ```bash
      chmod 777 ${WORK_DIR}/config/wdz.sh
      ```

    - ##### 添加软链接

      ```bash
      ln -sf ${WORK_DIR}/config/wdz.sh /usr/local/bin/wdz
      ```
      > 也可以将 `wdz` 修改成你想叫的名字

  - #### 更新方法

    - ##### 执行安装方法的前二步

  - #### 使用方法

    ```bash
    wdz <活动链接>
    ```
    ?> 如果链接中存在 `&` 符号则需要在链接的两侧加上引号以表示整体

    > [!TIP]
    > 如果需要自定义某些功能请自行修改脚本内容
ㅤ

***

## 活动脚本


- ### 赚京豆

  > [!WARNING|label:加密脚本]
  > 怕偷ck者别用

  > 目前已无法兑换成喜豆

  - #### 定时配置

    ```cron
    10 6 * * * task /jd/own/SuperManito_touluyyds/tools/jd_syj.js now -l 2
    ```
    > 建议自定义定时不要都挤一个点

  - #### 配置助力账号

    > 需要制定被助力账号，变量值为 `pt_pin` 的值，多个用 `&` 进行分割
    ```bash
    export SYJ_HELP_PIN=""
    ```

    > [!NOTE|label:详细说明]
    > 单个账号每天可开 `3` 次团，可助力他人 `3` 次，但针对同一个账号每天只能助力一次（3次机会不能全部用于助力同一个账号）\
    > 助力显示火爆即代表当天已助力过目标账号忽略即可，每10个账号可以养3个号，开团时间没有规则限制


- ### 发财挖宝

  > [!NOTE|label:活动说明]
  > 活动入口: 京东极速版 > 我的 > 发财挖宝\
  > 活动奖品: 最高可得总和为10元的微信零钱和红包\
  > 活动有 `入门`、`挑战`、`终极` 总共三个等级难度的关卡，并且奖励分开计算\
  > 每关分别存在 `4`、`8`、`12` 个炸弹，挖到炸弹会掉一滴血

  > [!WARNING|label:活动须知]
  > 必须剩 `1` 血才能领取奖励，目前需要手动完成逛一逛任务和下单任务才能通关，不做的话助力满后大概可得 `1.0～2` 块的微信零钱

  > [!TIP]
  > 至少需要 `10` 个帐号，因为第一关的奖励很少几乎等于无，自行安排定时任务，需先跑助力

  - #### 邀请好友助力

    ```bash
    task /jd/own/SuperManito_touluyyds/tools/jd_fcwb_help.js now
    ```
    > 仅会助力第一个号，助力满后脚本自动停止，目前助力上限为 `30`，每邀请两个人加一滴血

  - #### 挖宝

    > [!ATTENTION]
    > 目前需要手动打开APP进入一次活动否则跑脚本可能全是券，或者助力完了手动挖宝\
    > 如果挖到了优惠券则说明号已黑，有时候跑的很晚也会出券，可能没水了

    ```bash
    task /jd/own/SuperManito_touluyyds/tools/jd_fcwb.py now
    ```
    > 此脚本功能只有挖宝和提现没有助力功能，当剩余 `1` 滴血时停止挖宝，会领取关卡奖励并提现微信零钱


- ### 东东农场

  > H5st新版，可能已经验证该算法参数，如若仍使用旧版脚本可能会导致账号被风控

  - #### 定时配置

    ```cron
    15 6-18/6 * * * task /jd/own/SuperManito_touluyyds/tools/jd_fruit.js
    ```

    > [!TIP]
    > 设置定时后请注释原有相关旧版脚本定时

  - #### 攒水滴控制变量

    ```bash
    export DO_TEN_WATER_AGAIN=""
    ```
    > 默认不攒 `true` ，如想攒请赋值为 `false` ，配置文件默认已预留此变量的模版，不要重复添加


- ### 头文字J

  > [!WARNING|label:加密脚本]
  > 怕偷ck者别用

  > [!NOTE|label:活动说明]
  > 活动入口: 京东APP首页 > 京东汽车 > 领京豆\
  > 做任务积攒一定的能量兑换京豆

  - #### 定时配置

    ```cron
    16 16,17,18 * * * task /jd/own/SuperManito_touluyyds/tools/jd_mpdzcarJ.js
    ```
    > 脚本容易 493 黑IP，不知道什么时候会解开
# Helloworld

- **一个稳定安全、简单易用、强大CLI命令支持的薅羊毛运行环境，拥有控制面板和应用开放接口** <!-- {docsify-ignore} -->

- **支持运行 `JavaScript` `Python` `TypeScript` `Shell` 脚本，可自动配置相关定时计划任务** <!-- {docsify-ignore} -->

- **这是一个免费的公益项目，任何人都可以在自己的设备上安装和使用** <!-- {docsify-ignore} -->

- **底层代码没有植入关于作者的任何互助码，不会收集您的任何隐私内容** <!-- {docsify-ignore} -->

> :fa-brands fa-telegram: [电报频道](https://t.me/jdhelloworld)&emsp;&emsp;:fa-solid fa-warehouse:[ 镜像仓库](https://hub.docker.com/r/supermanito/helloworld)

## :fa-regular fa-command: CLI 命令 <!-- {docsify-ignore} -->

```
❖  task <name/path/url> now          ✧ 普通执行，前台运行并在命令行输出进度，可选参数(支持多个，加在末尾)：-<l/m/w/d/p/r/c/g/b>
❖  task <name/path/url> conc         ✧ 并发执行，后台运行不在命令行输出进度，可选参数(支持多个，加在末尾)：-<m/w/d/p/r/c>
❖  task <name/path> pkill            ✧ 终止执行，根据脚本匹配对应的进程并立即杀死，当脚本报错死循环时建议使用
❖  source runall                     ✧ 全部执行，在选择运行模式后执行指定范围的脚本(交互)，非常耗时不要盲目使用

❖  task repo <url> <branch> <path>   ✧ 添加 Own Repo 扩展仓库功能，拉取仓库至本地后自动添加相关变量并配置定时任务
❖  task raw <url>                    ✧ 添加 Own RawFile 扩展脚本功能，单独拉取脚本至本地后自动添加相关变量并配置定时任务

❖  task ps                           ✧ 查看资源消耗情况和正在运行的脚本进程
❖  task rmlog                        ✧ 删除一定天数的由项目和运行脚本产生的各类日志文件
❖  task cleanup                      ✧ 检测并终止卡死状态的脚本进程，以释放内存占用提高运行效率

❖  task list                         ✧ 列出本地脚本清单
❖  task exsc                         ✧ 导出互助码变量和助力格式，互助码从最后一个日志提取，受日志内容影响
❖  task cookie <cmd>                 ✧ 检测本地账号是否有效 check、使用WSKEY更新CK update
❖  task env <cmd>                    ✧ 管理全局环境变量功能(交互)，添加 add、删除 del、修改 edit、查询 search，支持快捷命令
❖  task notify <title> <content>     ✧ 自定义推送通知消息，参数为标题加内容，支持转义字符

❖  taskctl server status             ✧ 查看各服务的详细信息，包括运行状态、创建时间、处理器占用、内存占用、运行时长
❖  taskctl hang <cmd>                ✧ 后台挂机程序(后台循环执行活动脚本)功能控制，启动或重启 up、停止 down、查看日志 logs
❖  taskctl panel <cmd>               ✧ 控制面板和网页终端功能控制，开启或重启 on、关闭 off、登录信息 info、重置密码 respwd
❖  taskctl jbot <cmd>                ✧ 电报机器人功能控制，启动或重启 start、停止 stop、查看日志 logs、更新升级 update
❖  taskctl env <cmd>                 ✧ 执行环境软件包相关命令(支持 TypeScript 和 Python )，安装 install、修复 repairs
❖  taskctl check files               ✧ 检查项目相关配置文件是否存在，如果缺失就从模板导入

❖  update | update all               ✧ 全部更新，包括项目源码、所有仓库和脚本、自定义脚本等
❖  update <cmd/path>                 ✧ 单独更新，项目源码 shell、主要仓库 scripts、扩展仓库 own、所有仓库 repo、扩展脚本 raw
                                                自定义脚本 extra、指定仓库 <path>

❋ 基本命令注释：
   <name> 脚本名（仅限scripts目录）;  <path> 相对路径或绝对路径;  <url> 脚本链接地址;  <cmd> 固定可选的子命令

❋ 用于执行脚本的可选参数：
   -l | --loop          循环运行，连续多次的执行脚本，参数后需跟循环次数
   -m | --mute          静默运行，不推送任何通知消息
   -w | --wait          等待执行，等待指定时间后再运行任务，参数后需跟时间值
   -d | --delay         延迟执行，随机倒数一定秒数后再执行脚本
   -p | --proxy         下载代理，仅适用于执行位于 GitHub 仓库的脚本
   -r | --rapid         迅速模式，不组合互助码等步骤降低脚本执行前耗时
   -c | --cookie        指定账号，参数后需跟账号序号，多个账号用 "," 隔开，账号区间用 "-" 连接，可以用 "%" 表示账号总数
   -g | --grouping      账号分组，每组账号单独运行脚本，参数后需跟账号序号并分组，参数用法跟指定账号一样，组与组之间用 "@" 隔开
   -b | --background    后台运行，不在前台输出脚本执行进度
```

## :fa-duotone fa-browser: 控制面板 <!-- {docsify-ignore} -->

![登录页](./img/panel/1.png ':size=640x340')
![内容页](./img/panel/2.png ':size=640x340')

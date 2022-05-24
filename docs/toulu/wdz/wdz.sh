#!/bin/bash
## cjhy 微定制一键脚本
## Version: 1.0
## Author: SuperManito
## Modified: 2022-05-24

## 执行位置判定
if [ ${WORK_DIR} ]; then
    . ${WORK_DIR}/shell/share.sh
else
    echo -e "\n[\033[31mERROR\033[0m] 请进入容器内执行此脚本！\n"
    exit
fi

cd ${WORK_DIR}

## 加载环境变量
Import_Config_Not_Check
Count_UserSum

## 使用帮助
function Help() {
    if [ -x /usr/local/bin/wdz ]; then
        echo -e "\n${GREEN}使用方法${PLAIN}：在 ${BLUE}wdz${PLAIN} 后面加上活动链接\n"
    else
        echo -e "\n${GREEN}使用方法${PLAIN}：使用 ${BLUE}bash${PLAIN} 执行此脚本并在后面加上活动链接\n"
    fi
}

## 随机定义一个UA
function Get_User_Agents() {
    local UA_Arrary=(
        '613800945610|1613824900;adk/;app_device/IOS;pap/JA2020_3112531|3.1.0|IOS 14.3;Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
        'jdltapp;android;3.1.0;9;D246836333735-3264353430393;network/4g;model/MIX 2;addressid/138678023;aid/bf8bcf1214b3832a;oaid/308540d1f1feb2f5;osVer/28;appBuild/1436;psn/Z/rGqfWBY/h5gcGFnVIsRw==|16;psq/3;adk/;ads/;pap/JA2020_3112531|3.1.0|ANDROID 9;osv/9;pv/13.7;jdv/;ref/com.jd.jdlite.lib.personal.view.fragment.JDPersonalFragment;partner/xiaomi;apprpd/MyJD_Main;eufv/1;Mozilla/5.0 (Linux; Android 9; MIX 2 Build/PKQ1.190118.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/66.0.3359.126 MQQBrowser/6.2 TBS/045135 Mobile Safari/537.36'
        'jdltapp;iPhone;2.1.0;14.4;eb5a9e7e596e262b4ffb3b6b5c830984c8a5c0d5;network/wifi;ADID/5603541B-30C1-4B5C-A782-20D0B569D810;hasUPPay/0;pushNoticeIsOpen/0;lang/zh_CN;model/iPhone9,2;addressid/1041002757;hasOCPay/0;appBuild/101;supportBestPay/0;pv/34.6;apprpd/MyJD_Main;ref/MyJdMTAManager;psq/5;ads/;psn/eb5a9e7e596e262b4ffb3b6b5c830984c8a5c0d5|44;jdv/0|androidapp|t_335139774|appshare|CopyURL|1612612940307|1612612944;adk/;app_device/IOS;pap/JA2020_3112531|2.1.0|IOS 14.4;Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
        'jdltapp;iPhone;3.1.0;14.3;21631ed983b3e854a3154b0336413825ad0d6783;network/3g;hasUPPay/0;pushNoticeIsOpen/0;lang/zh_CN;model/iPhone13,4;addressid/;hasOCPay/0;appBuild/1017;supportBestPay/0;pv/4.47;apprpd/;ref/JDLTSubMainPageViewController;psq/8;ads/;psn/21631ed983b3e854a3154b0336413825ad0d6783|9;jdv/0|direct|-|none|-|1614150725100|1614225882;adk/;app_device/IOS;pap/JA2020_3112531|3.1.0|IOS 14.3;Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
        'jdltapp;iPhone;3.1.0;13.5;500a795cb2abae60b877ee4a1930557a800bef1c;network/wifi;hasUPPay/0;pushNoticeIsOpen/0;lang/zh_CN;model/iPhone8,1;addressid/669949466;hasOCPay/0;appBuild/1017;supportBestPay/0;pv/9.11;apprpd/;ref/JDLTSubMainPageViewController;psq/10;ads/;psn/500a795cb2abae60b877ee4a1930557a800bef1c|11;jdv/;adk/;app_device/IOS;pap/JA2020_3112531|3.1.0|IOS 13.5;Mozilla/5.0 (iPhone; CPU iPhone OS 13_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
        'jdltapp;iPad;3.1.0;14.4;f5e7b7980fb50efc9c294ac38653c1584846c3db;network/wifi;hasUPPay/0;pushNoticeIsOpen/1;lang/zh_CN;model/iPad6,3;hasOCPay/0;appBuild/1017;supportBestPay/0;pv/231.11;pap/JA2020_3112531|3.1.0|IOS 14.4;apprpd/;psn/f5e7b7980fb50efc9c294ac38653c1584846c3db|305;usc/kong;jdv/0|kong|t_1000170135|tuiguang|notset|1613606450668|1613606450;umd/tuiguang;psq/2;ucp/t_1000170135;app_device/IOS;utr/notset;ref/JDLTRedPacketViewController;adk/;ads/;Mozilla/5.0 (iPad; CPU OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
        'jdltapp;iPhone;3.1.0;14.4;19fef5419f88076c43f5317eabe20121d52c6a61;network/wifi;ADID/00000000-0000-0000-0000-000000000000;hasUPPay/0;pushNoticeIsOpen/0;lang/zh_CN;model/iPhone11,8;addressid/3430850943;hasOCPay/0;appBuild/1017;supportBestPay/0;pv/10.4;apprpd/;ref/JDLTSubMainPageViewController;psq/3;ads/;psn/19fef5419f88076c43f5317eabe20121d52c6a61|16;jdv/0|kong|t_1001327829_|jingfen|f51febe09dd64b20b06bc6ef4c1ad790#/|1614096460311|1614096511;adk/;app_device/IOS;pap/JA2020_3112531|3.1.0|IOS 14.4;Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148'
        'jdltapp;iPhone;3.1.0;12.2;f995bc883282f7c7ea9d7f32da3f658127aa36c7;network/4g;ADID/9F40F4CA-EA7C-4F2E-8E09-97A66901D83E;hasUPPay/0;pushNoticeIsOpen/0;lang/zh_CN;model/iPhone10,4;addressid/525064695;hasOCPay/0;appBuild/1017;supportBestPay/0;pv/11.11;apprpd/;ref/JDLTSubMainPageViewController;psq/2;ads/;psn/f995bc883282f7c7ea9d7f32da3f658127aa36c7|22;jdv/0|;adk/;app_device/IOS;pap/JA2020_3112531|3.1.0|IOS 12.2;Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
        'jdltapp;android;3.1.0;10;5366566313931326-6633931643233693;network/wifi;model/Mi9 Pro 5G;addressid/0;aid/5fe6191bf39a42c9;oaid/e3a9473ef6699f75;osVer/29;appBuild/1436;psn/b3rJlGi AwLqa9AqX7Vp0jv4T7XPMa0o|5;psq/4;adk/;ads/;pap/JA2020_3112531|3.1.0|ANDROID 10;osv/10;pv/5.4;jdv/;ref/HomeFragment;partner/xiaomi;apprpd/Home_Main;eufv/1;Mozilla/5.0 (Linux; Android 10; Mi9 Pro 5G Build/QKQ1.190825.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/66.0.3359.126 MQQBrowser/6.2 TBS/045135 Mobile Safari/537.36'
        'jdltapp;iPhone;3.1.0;14.4;4e6b46913a2e18dd06d6d69843ee4cdd8e033bc1;network/3g;hasUPPay/0;pushNoticeIsOpen/0;lang/zh_CN;model/iPhone13,2;addressid/666624049;hasOCPay/0;appBuild/1017;supportBestPay/0;pv/54.11;apprpd/MessageCenter_MessageMerge;ref/MessageCenterController;psq/10;ads/;psn/4e6b46913a2e18dd06d6d69843ee4cdd8e033bc1|101;jdv/0|kong|t_2010804675_|jingfen|810dab1ba2c04b8588c5aa5a0d44c4bd|1614183499;adk/;app_device/IOS;pap/JA2020_3112531|3.1.0|IOS 14.4;Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1'
    )
    Num=$((${RANDOM} % 10))
    UA="${UA_Arrary[Num]}"
}

## 开卡
function Run_OpenCard() {

    function Run() {
        ## 执行开卡脚本
        bash -c "$TaskCmd $OpenCard_ScriptFile now -r -m -b" >/dev/null 2>&1 &
    }

    ## 定义环境变量
    function Env() {
        bash -c "$TaskCmd env edit VENDER_ID \"${venderId}\"" >/dev/null 2>&1
    }

    function Save() {
        while true; do
            if [ -d $OpenCard_LogFileDir ]; then
                if [[ $(ls $OpenCard_LogFileDir 2>/dev/null) ]]; then
                    ## 5分钟内不重复运行开卡（前提是已经运行结束的）

                    ls $OpenCard_LogFileDir 2>/dev/null | grep ".*-${venderId}.log" -Eq
                    if [ $? -eq 0 ]; then

                        local Tmp_File="$(ls -r $OpenCard_LogFileDir 2>/dev/null | grep ".*-${venderId}.log" | head -1)"
                        local Tmp_File_Time_Content="$(echo "${Tmp_File}" | awk -F "-${venderId}" '{print$1}')"
                        local Tmp_Arrary=(
                            $(echo "${Tmp_File_Time_Content}" | sed "s/-/ /g")
                        )
                        local Tmp_File_Time="${Tmp_Arrary[0]}-${Tmp_Arrary[1]}-${Tmp_Arrary[2]} ${Tmp_Arrary[3]}:${Tmp_Arrary[4]}:${Tmp_Arrary[5]}"
                        local LastOpenCardRunTime="$(date +%s -d "${Tmp_File_Time}")"
                        local TimeDifference=$(($StartRunTime - ${LastOpenCardRunTime}))
                        if [[ ${TimeDifference} -lt 300 ]]; then
                            break
                        fi

                    fi
                fi
            fi
            Run
            break
        done
    }

    if [[ ${venderId} ]]; then
        local OpenCard_ScriptFile="$OwnDir/SuperManito_touluyyds/tools/jd_OpenCard_Force.js"
        local OpenCard_LogFileDir="$LogDir/SuperManito_touluyyds_jd_OpenCard_Force"
        [ ! -s $OpenCard_ScriptFile ] && echo -e "\n$ERROR 开卡脚本不存在，请先拉取或更新仓库！\n" && exit
        Env
        Run
    fi

}

## 获取活动信息
function Get_Activity_Info() {
    local Request_Result

    ## 获取 LZ_TOKEN_KEY 和 LZ_TOKEN_VALUE（貌似有效期很短）
    function Get_LZ_TOKEN() {
        local GET_LOG="$RootDir/.get_lz_token.log"

        case ${Run_Mod} in
        lzkj)
            ## 尝试三次
            for ((n = 1; n < 4; n++)); do
                curl -s -X POST "https://lzkjdz-isv.isvjd.com/wxCommonInfo/token" >$GET_LOG

                ## 判定请求结果
                if [[ "$(cat $GET_LOG)" != "" ]]; then
                    Request_Result=$(cat $GET_LOG | jq '.result' 2>/dev/null)
                else
                    Request_Result="false"
                fi
                if [[ ${Request_Result} == "true" ]]; then
                    LZ_TOKEN_KEY=$(cat $GET_LOG | jq .data.LZ_TOKEN_KEY 2>/dev/null | sed "s/\"//g")
                    LZ_TOKEN_VALUE=$(cat $GET_LOG | jq .data.LZ_TOKEN_VALUE 2>/dev/null | sed "s/\"//g")
                    break
                fi
                ## 报错获取失败，执行失败模式
                if [ $n = "3" ]; then
                    echo -e "\n\n[${BLUE}$(date "+%Y-%m-%d %T")${PLAIN}] - $ERROR 接口 ${BLUE}wxCommonInfo/token${PLAIN} 请求异常，未能获取到 ${BLUE}LZ_TOKEN${PLAIN}！"
                    Failure_Mode
                    exit
                fi
            done
            ;;

        cjhy)
            curl -sI GET "${URL}" >$GET_LOG
            if [ $? -eq 0 ]; then
                LZ_TOKEN_KEY=$(grep "LZ_TOKEN_KEY" $GET_LOG | perl -pe "{s|.*LZ_TOKEN_KEY=([^; ]+)(?=;?).*|\1|}")
                LZ_TOKEN_VALUE=$(grep "LZ_TOKEN_VALUE" $GET_LOG | perl -pe "{s|.*LZ_TOKEN_VALUE=([^; ]+)(?=;?).*|\1|}")
            else
                echo -e "\n[${BLUE}$(date "+%Y-%m-%d %T")${PLAIN}] - $ERROR 活动页火爆，未能获取到 ${BLUE}LZ_TOKEN${PLAIN}！"
                Failure_Mode
                exit
            fi
            ;;
        esac

        [ -f $GET_LOG ] && rm -rf $GET_LOG
    }

    ## 获取店主id
    function Get_venderId() {
        curl -s -X POST "${Activity_Domain}/microDz/invite/activity/wx/getActivityInfo" \
            -H 'Connection: keep-alive' \
            -H 'Accept: application/json' \
            -H 'X-Requested-With: XMLHttpRequest' \
            -H "User-Agent: ${UA}" \
            -H 'Content-Type: application/x-www-form-urlencoded' \
            -H "Origin: ${Activity_Domain}" \
            -H 'Sec-Fetch-Site: same-origin' \
            -H 'Sec-Fetch-Mode: cors' \
            -H 'Sec-Fetch-Dest: empty' \
            -H 'Accept-Language: zh-CN,zh;q=0.9' \
            -H "Cookie: LZ_TOKEN_KEY=${LZ_TOKEN_KEY}; LZ_TOKEN_VALUE=${LZ_TOKEN_VALUE}" \
            --data-raw "activityId=${activityId}" | jq .data.venderIds | sed "s/\"//g; s/,/\&/g" 2>/dev/null
    }

    ## 随机定义一个UA
    Get_User_Agents
    ## 获取 LZ_TOKEN
    Get_LZ_TOKEN
    ## 获取店主ID
    venderId=$(Get_venderId)
}

function Main() {

    ## 检查链接格式并定义基础变量
    function CheckUrl() {
        URL="$1"
        echo "${URL}" | grep -Eq "https://....dz-isv\.isv.*\.com/microDz/invite/activity/wx/view/index/.*\?activityId=.*"
        if [ $? -eq 0 ]; then
            ## 活动ID
            activityId=$(echo "${URL}" | perl -pe "{s|.*activityId=([^& ]+)(?=&?).*|\1|}")
            if [[ ${activityId} ]]; then
                ## 活动域名
                Activity_Domain="https://$(echo "${URL}" | awk -F '/' '{print$3}')"
                ## 活动域名类型
                Run_Mod=$(echo ${Activity_Domain} | cut -c 9-12)
                case ${Run_Mod} in
                cjhy) ;;
                *)
                    echo -e "\n$ERROR 活动链接有误，未能获取到活动类型！\n"
                    exit
                    ;;
                esac
            else
                echo -e "\n$ERROR 活动链接有误，未能获取到活动ID！\n"
                exit
            fi
        else
            echo -e "\n$ERROR 活动链接有误，请验证！\n"
            exit
        fi
    }
    ## 检查链接
    CheckUrl "$1"
    ## 获取活动信息
    Get_Activity_Info
    ## 先在后台开卡
    Run_OpenCard
    if [ -s "$OwnDir/SuperManito_touluyyds/tools/jd_jointeam.js" ]; then
        Run_File="/jd/own/SuperManito_touluyyds/tools/jd_jointeam.js"
    else
        Run_File="jd_jointeam.js"
    fi
    bash -c "$TaskCmd env edit jd_jointeam_activityUrl ${Activity_Domain} && $TaskCmd env edit jd_jointeam_activityId ${activityId}" >/dev/null 2>&1
    echo -e "\n❋ 执行命令: ${BLUE}$TaskCmd env edit VENDER_ID \"${venderId}\" && task /jd/own/SuperManito_touluyyds/tools/jd_OpenCard_Force.js now${PLAIN}"
    echo -e "\n先让开卡跑 5s ...\n"
    sleep 5
    echo -e "❋ 执行命令: ${BLUE}$TaskCmd ${Run_File} now${PLAIN}"
    bash -c "$TaskCmd ${Run_File} now"
}

case $# in
1)
    Main "$1"
    ;;
*)
    Help
    ;;
esac

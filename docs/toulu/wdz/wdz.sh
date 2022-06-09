#!/bin/bash
## cjhy 微定制一键脚本
## Version: 1.0
## Author: SuperManito
## Modified: 2022-06-09

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
        "jdapp;iPhone;10.1.6;13.7;network/wifi;Mozilla/5.0 (iPhone; CPU iPhone OS 13_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1",
        "jdapp;iPhone;10.1.6;14.1;network/wifi;Mozilla/5.0 (iPhone; CPU iPhone OS 14_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1",
        "jdapp;iPhone;10.1.6;13.3;network/wifi;Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1",
        "jdapp;iPhone;10.1.6;13.4;network/wifi;Mozilla/5.0 (iPhone; CPU iPhone OS 13_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1",
        "jdapp;iPhone;10.1.6;14.3;network/wifi;Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1",
        "jdapp;android;10.1.6;9;network/wifi;Mozilla/5.0 (Linux; Android 9; MI 6 Build/PKQ1.190118.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/66.0.3359.126 MQQBrowser/6.2 TBS/044942 Mobile Safari/537.36",
        "jdapp;android;10.1.6;11;network/wifi;Mozilla/5.0 (Linux; Android 11; Redmi K30 5G Build/RKQ1.200826.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/77.0.3865.120 MQQBrowser/6.2 TBS/045511 Mobile Safari/537.36",
        "jdapp;android;10.1.6;11;network/wifi;Mozilla/5.0 (Linux; Android 11; Redmi K20 Pro Premium Edition Build/RKQ1.200826.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/77.0.3865.120 MQQBrowser/6.2 TBS/045513 Mobile Safari/537.36",
        "jdapp;android;10.1.6;10;network/wifi;Mozilla/5.0 (Linux; Android 10; M2006J10C Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/77.0.3865.120 MQQBrowser/6.2 TBS/045230 Mobile Safari/537.36",
        "jdapp;android;10.1.6;11;network/wifi;Mozilla/5.0 (Linux; Android 11; Redmi K30 5G Build/RKQ1.200826.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/77.0.3865.120 MQQBrowser/6.2 TBS/045511 Mobile Safari/537.36",
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
    local result

    ## 获取 LZ_TOKEN_KEY 和 LZ_TOKEN_VALUE（貌似有效期很短）
    function Get_LZ_TOKEN() {
        local GET_LOG="$RootDir/.get_lz_token.log"

        case ${Run_Mod} in
        lzkj)
            ## 尝试三次
            for ((n = 1; n < 4; n++)); do
                curl -s -X POST "https://lzkj-isv.isvjd.com/wxCommonInfo/token" >$GET_LOG

                ## 判定请求结果
                if [[ "$(cat $GET_LOG)" != "" ]]; then
                    result=$(cat $GET_LOG | jq .result 2>/dev/null)
                else
                    result="false"
                fi
                if [[ ${result} == "true" ]]; then
                    LZ_TOKEN_KEY=$(cat $GET_LOG | jq -r .data.LZ_TOKEN_KEY 2>/dev/null)
                    LZ_TOKEN_VALUE=$(cat $GET_LOG | jq -r .data.LZ_TOKEN_VALUE 2>/dev/null)
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

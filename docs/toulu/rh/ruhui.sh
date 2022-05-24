#!/bin/bash
## 一键入会领豆 - 辅助工具脚本
## Version: 2.2
## Author: SuperManito
## Modified: 2022-05-24

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 用 户 定 义 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #

## ❖ 定义最低入会豆数变量（低于这个数量的店铺则不会入会）
MinimumBeans="10"

####################################################################

## 执行位置判定
if [ ${WORK_DIR} ]; then
    . ${WORK_DIR}/shell/share.sh
else
    echo -e "\n[\033[31mERROR\033[0m] 请进入容器内执行此脚本！\n"
fi

## 使用帮助
function Help() {
    if [ -x /usr/local/bin/rh ]; then
        echo -e "\n${GREEN}使用方法${PLAIN}：在 ${BLUE}rh${PLAIN} 后面加上参数，参数内容为 ${BLUE}店铺链接${PLAIN} 或 ${BLUE}venderId${PLAIN} 的值，如果是链接则仅支持单个，可使用 ${BLUE}-f${PLAIN} 或 ${BLUE}--force${PLAIN} 参数强制入会\n"
    else
        echo -e "\n${GREEN}使用方法${PLAIN}：使用 ${BLUE}bash${PLAIN} 执行此脚本并在后面加上参数，参数内容为 ${BLUE}店铺链接${PLAIN} 或 ${BLUE}venderId${PLAIN} 的值，的值，如果是链接则仅支持单个，可使用，可使用 ${BLUE}-f${PLAIN} 或 ${BLUE}--force${PLAIN} 参数强制入会\n"
    fi
}

function Main() {

    ## 变量
    LocalTargetDir=$OwnDir/SuperManito_touluyyds/tools

    if [[ ${Force_Mod} == "false" ]]; then
        LocalTargetScript=$LocalTargetDir/jd_OpenCard.js
    else
        LocalTargetScript=$LocalTargetDir/jd_OpenCard_Force.js
    fi

    ## 获取店铺ID
    function GetVenderId() {
        local InputContent="$1"
        ## 判断链接是否含有 shopId
        echo "${InputContent}" | grep "shopId=" -Eq
        ExitStatus_shopId=$?
        ## 判断链接是否含有 venderId
        echo "${InputContent}" | grep "venderId=" -Eq
        ExitStatus_venderId=$?

        echo "${InputContent}" | grep "^https\?:" -q
        ## 传入的是链接地址
        if [ $? -eq 0 ]; then
            SHOP_ID=$(echo "${InputContent}" | perl -pe "{s|.*shopId=([^& ]+)(?=;?).*|\1|}")
            if [[ $ExitStatus_venderId -eq 0 ]]; then
                VENDER_ID=$(echo "${InputContent}" | perl -pe "{s|.*venderId=([^& ]+)(?=;?).*|\1|}")
            else
                if [[ $ExitStatus_shopId -ne 0 ]]; then
                    echo -e "\n$ERROR 传入链接格式有误，至少需要 ${BLUE}venderId${PLAIN} 或 ${BLUE}shopId${PLAIN} 其中一个！\n"
                    exit
                fi
                ## 判断是否为自营店铺（部分自营店铺两者的值相等）
                if [[ ${#SHOP_ID} -eq 10 ]]; then
                    VENDER_ID=$SHOP_ID
                else
                    echo -e "\n$WORKING 检测到未提供 ${BLUE}venderId${PLAIN} ，尝试获取..."
                    local URL="https://shop.m.jd.com/mshop/QueryShopMemberInfoJson?shopId=${SHOP_ID}&_=$(date +%s)000&sceneval=2"
                    local UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36"
                    local COOKIE="pt_key=donggenb;pt_pin=donggenb;"
                    local REFERER_URL="https://shop.m.jd.com/?shopId=${SHOP_ID}"
                    local GET_CONTENT=$(curl -s -L -X GET "${URL}" -H "User-Agent: ${UA}" -H "referer: ${REFERER_URL}" -H "Cookie: ${Cookie}" 2>/dev/null)
                    local SHOP_NAME=$(echo "${GET_CONTENT}" | jq '.["shopName"]' | sed "s/[\"\']//g")
                    VENDER_ID=$(echo "${GET_CONTENT}" | jq '.["venderId"]')

                    if [[ ${VENDER_ID} ]]; then
                        echo -e "\n店铺名称：${SHOP_NAME}\n店主 ID ：${VENDER_ID}\n店铺链接：https://shop.m.jd.com/?venderId=${VENDER_ID}&shopId=${SHOP_ID}"
                        echo -e "\n$SUCCESS 获取成功"
                    fi
                fi
            fi

        ## 传入的是数字ID
        else
            echo "${InputContent}" | grep -Eq "[a-zA-Z\.\<\>;:/\!#$^*|\-_=\+]|\(|\)|\[|\]|\{|\}"
            if [ $? -eq 0 ]; then
                echo -e "\n$ERROR 传入参数的格式不正确！\n"
                exit
            else
                VENDER_ID=${InputContent}
            fi
        fi

        echo ''
    }
    ## 定义相关环境变量
    function ChangeEnv() {
        if [[ ${Force_Mod} == "false" ]]; then
            grep "^export OPENCARD_BEAN=" $FileConfUser -q
            if [ $? -eq 0 ]; then
                bash -c "$TaskCmd env edit OPENCARD_BEAN ${MinimumBeans} >/dev/null 2>&1"
            else
                bash -c "$TaskCmd env add OPENCARD_BEAN ${MinimumBeans} '最低入会豆数' >/dev/null 2>&1"
            fi
        fi
        grep "^export VENDER_ID=" $FileConfUser -q
        if [ $? -eq 0 ]; then
            bash -c "$TaskCmd env edit VENDER_ID $VENDER_ID >/dev/null 2>&1"
        else
            bash -c "$TaskCmd env add VENDER_ID $VENDER_ID '入会店铺ID' >/dev/null 2>&1"
        fi
    }

    GetVenderId "$1"
    ChangeEnv

    ## 判断执行模式（如果已拉取own仓库就执行本地脚本，否则远程执行脚本）
    if [ -s $LocalTargetScript ]; then
        bash -c "$TaskCmd $LocalTargetScript now -m -r"
    else
        echo -e "\n$ERROR 开卡脚本不存在，请先拉取或更新仓库！\n" && exit
    fi

    echo -e "\n$COMPLETE 执行结束\n"
}

case $# in
1)
    Force_Mod="false"
    Main "$1"
    ;;
2)
    if [[ "$1" == "-f" ]] || [[ "$1" == "--force" ]]; then
        Force_Mod="true"
        Main "$2"
    elif [[ "$2" == "-f" ]] || [[ "$2" == "--force" ]]; then
        Force_Mod="true"
        Main "$1"
    else
        echo -e "\n$ERROR 参数错误！\n"
        exit
    fi
    ;;
*)
    Help
    ;;
esac

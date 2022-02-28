#!/bin/bash
## 一键入会领豆 - 辅助工具脚本
## Version: 1.0
## Author: SuperManito
## Modified: 2022-02-28

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 用 户 定 义 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #

## ❖ 定义最低入会豆数变量（低于这个数量的店铺则不会入会）
MinimumBeans=10

## ❖ 是否推送通知
# 默认关闭，如想启用请修改为 "True"
SendNotify=False

####################################################################

## 执行位置判定
if [ ${WORK_DIR} ]; then
    . ${WORK_DIR}/shell/share.sh
else
    echo -e "\n[\033[31mERROR\033[0m] 请进入容器内执行此脚本！\n"
fi

## 变量
LocalTargetDir=$OwnDir/curtinlv_JD-Script/OpenCard
LocalTargetScript=$LocalTargetDir/jd_OpenCard.py
LocalFileShopID=$LocalTargetDir/shopid.txt
RemoteTargetDir=$ScriptsDir
RemoteTargetScript="https://raw.fastgit.org/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py"
RemoteFileShopID=$RemoteTargetDir/shopid.txt

## 使用帮助
function Help() {
    if  [ -x /usr/local/bin/rh ]; then
        echo -e "\n${GREEN}使用方法${PLAIN}：在 ${BLUE}rh${PLAIN} 后面加上参数，参数内容为 ${BLUE}店铺链接${PLAIN} 或 关于${BLUE}shopId${PLAIN} ，每次运行仅支持入会单个店铺\n"
    else
        echo -e "\n${GREEN}使用方法${PLAIN}：使用 ${BLUE}bash${PLAIN} 执行此脚本并在后面加上参数，参数内容为 ${BLUE}店铺链接${PLAIN} 或 关于${BLUE}shopId${PLAIN} ，每次运行仅支持入会单个店铺\n"
    fi
}

function Main() {

    ## 获取店铺ID
    function GetShopId() {
        local InputContent="$1"
        echo "${InputContent}" | grep "^https\?:" -q
        ## 传入的是链接地址
        if [ $? -eq 0 ]; then
            echo "${InputContent}" | grep "shopId=" -q
            if [ $? -eq 0 ]; then
                SHOP_ID=$(echo "${InputContent}" | perl -pe "{s|.*shopId=([^& ]+)(?=;?).*|\1|}")
            else
                echo -e "\n$WORKING 检测到未提供 ${BLUE}shopId${PLAIN} ，尝试获取..."
                ## 在仅提供了 venderId 的情况下获取 shopId
                echo "${InputContent}" | grep "venderId=" -q
                if [ $? -eq 0 ]; then
                    VENDER_ID=$(echo "${InputContent}" | perl -pe "{s|.*venderId=([^& ]+)(?=;?).*|\1|}")

                    local URL="https://shop.m.jd.com/mshop/QueryShopMemberInfoJson?venderId=${VENDER_ID}&_=$(date +%s)000&sceneval=2"
                    local UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36"
                    local COOKIE="pt_key=donggenb;pt_pin=donggenb;"
                    local REFERER_URL="https://shop.m.jd.com/?venderId=${VENDER_ID}"
                    local GET_CONTENT=$(curl -s -L -X GET "${URL}" -H "User-Agent: ${UA}" -H "referer: ${REFERER_URL}" -H "Cookie: ${Cookie}" 2>/dev/null)
                    local SHOP_NAME=$(echo "${GET_CONTENT}" | jq '.["shopName"]' | sed "s/[\"\']//g")
                    SHOP_ID=$(echo "${GET_CONTENT}" | jq '.["shopId"]')

                    echo -e "\n店铺名称：${SHOP_NAME}\n店铺 ID ：${SHOP_ID}\n店铺链接：https://shop.m.jd.com/?venderId=${VENDER_ID}&shopId=${SHOP_ID}"
                    echo -e "\n$SUCCESS 获取成功"
                else
                    echo -e "\n$ERROR 传入的店铺链接格式有误！"
                    echo -e "\n$TIPS 至少需要关于 ${BLUE}shopId${PLAIN} 和 ${BLUE}venderId${PLAIN} 的其中任意一个参数和对应参数值！\n"
                    exit
                fi
            fi
            ## 判定是否获取到了 shopId
            if [[ -z ${SHOP_ID} ]]; then
                echo -e "\n$FAIL 未能获取到 ${BLUE}shopId${PLAIN} ，请检查原因后重试！\n"
                exit
            fi

        ## 传入的是数字ID
        else
            echo "${InputContent}" | grep -Eq "[a-zA-Z\.\<\>;:/\!#$^*|\-_=\+]|\(|\)|\[|\]|\{|\}"
            if [ $? -eq 0 ]; then
                echo -e "\n$ERROR 传入参数的格式不正确！\n"
                exit
            else
                SHOP_ID=${InputContent}
            fi
        fi

        echo ''
    }

    ## 定义相关环境变量
    function ChangeEnv() {
        grep "^export openCardBean=" $FileConfUser -q
        if [ $? -eq 0 ]; then
            bash -c "$TaskCmd env edit openCardBean ${MinimumBeans} >/dev/null 2>&1"
        else
            bash -c "$TaskCmd env add openCardBean ${MinimumBeans} 'Python 开卡脚本使用本地店铺ID' >/dev/null 2>&1"
        fi
        grep "^export isRemoteSid=" $FileConfUser -q
        if [ $? -eq 0 ]; then
            bash -c "$TaskCmd env edit isRemoteSid False >/dev/null 2>&1"
        else
            bash -c "$TaskCmd env add isRemoteSid False 'Python 开卡脚本最低入会豆数' >/dev/null 2>&1"
        fi
    }

    GetShopId "$1"
    ChangeEnv

    ## 判定是否推送通知
    if [[ ${SendNotify} == Fasle ]]; then
        local NotifyParameters=" -m"
    else
        local NotifyParameters=""
    fi

    ## 判断执行模式（如果已拉取own仓库就执行本地脚本，否则远程执行脚本）
    if [ -f $LocalTargetScript ]; then
        echo "${SHOP_ID}" >$LocalFileShopID
        bash -c "$TaskCmd $LocalTargetScript now${NotifyParameters}"
    else
        echo "${SHOP_ID}" >$RemoteFileShopID
        bash -c "$TaskCmd $RemoteTargetScript now${NotifyParameters}"
    fi

    echo -e "\n$COMPLETE 执行结束\n"
}

case $# in
1)
    Main "$1"
    ;;
*)
    Help
    ;;
esac

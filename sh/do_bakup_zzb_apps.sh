#!/bin/bash

zipfile=$1

# 打印帮助
print_help() {
    echo "  欢迎使用 itbread 的配置文件备份工具 $0:"
    echo "  用法如下:"
    echo "  $0 配置备份压缩包名称              "
}

zipfile=$1

do_backup_apps() {

    echo "start zip zzb apps files"

    zip -r $zipfile \
        "/opt/zzb/booking_service" \
        "/opt/zzb/cms_service" \
        "/opt/zzb/coach_service" \
        "/opt/zzb/device_service" \
        "/opt/zzb/extend_service" \
        "/opt/zzb/file_service" \
        "/opt/zzb/market_service" \
        "/opt/zzb/school_service" \
        "/opt/zzb/thirdparty" \
        "/opt/zzb/trade_service" \
        "/opt/zzb/user_service" \
        "/opt/zzb/bds_portal" \
        "/opt/zzb/device_portal" \
        "/opt/zzb/emp_portal" \
        "/opt/zzb/gmp_portal" \
        "/opt/zzb/stu_mp_portal" \
        "/opt/zzb/oms_mp_portal" \
        "/opt/zzb/zmp_portal" \
        "/opt/iot/api_gateway" \
        "/opt/iot/jtt808"

    echo "finish zip zzb apps files"
}

#判读参数并执行
case $# in
0)
    print_help "--help"
    ;;
1)
    if [ $1 = '--help' ] || [ $1 = '-help' ]; then
        print_help "--help 打印帮助"
    else
        do_backup_apps
    fi

    ;;
*)
    echo "  参数个数不对"
    ;;
esac

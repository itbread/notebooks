#!/bin/bash
# 打印帮助
print_help() {
    echo "  欢迎使用 itbread 的配置文件备份工具 $0:"
    echo "  用法如下:"
    echo "  $0 配置备份压缩包名称              "
}

zipfile=$1

do_backup_conf() {
    echo "start zip zzb conf files"

    zip -r $zipfile \
        "/etc/booking_service" \
        "/etc/cms_service" \
        "/etc/coach_service" \
        "/etc/device_service" \
        "/etc/extend_service" \
        "/etc/file_service" \
        "/etc/market_service" \
        "/etc/school_service" \
        "/etc/thirdparty" \
        "/etc/trade_service" \
        "/etc/user_service" \
        "/etc/bds_portal" \
        "/etc/device_portal" \
        "/etc/emp_portal" \
        "/etc/gmp_portal" \
        "/etc/stu_mp_portal" \
        "/etc/oms_mp_portal" \
        "/etc/zmp_portal" \
        "/etc/api_gateway" \
        "/etc/jtt808" \
        "/etc/nginx/conf.d"

    echo "finish zip zzb conf files"
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
        do_backup_conf
    fi

    ;;
*)
    echo "  参数个数不对"
    ;;
esac

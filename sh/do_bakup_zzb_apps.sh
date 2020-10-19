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
        "/opt/zzb" \
        "/opt/iot"

    echo "finish zip zzb apps files"
}

do_backup_db() {
    echo "start backup database zzb_db ..."
    echo "please input db password "
    pg_dump -h $db_service -p $db_port -U $db_user_name -f $backupfile $db_name

    echo "finish backup database zzb_db"
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

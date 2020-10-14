#!/bin/bash

backupfile=$1
#数据库服务器地址
db_service=127.0.0.1
#数据库端口
db_port=5432
#数据库名称
db_name=zzb_db
#数据库用户名
db_user_name=zzb_db

# 打印帮助
print_help() {
    echo "  欢迎使用 itbread 的数据库备份工具 $0:"
    echo "  用法如下:"
    echo "  $0 backup_file_name.sql              "
}

do_backup_db() {
    echo "start backup database zzb_db ..."
    echo "please input db password "
    pg_dump -h $db_service -p $db_port -U $db_user_name -f $backupfile $db_name

    echo "finish backup database zzb_db"
}

case $# in
0)
    print_help "--help"
    ;;
1)
    if [ $1 = '--help' ] || [ $1 = '-help' ]; then
        print_help "--help 打印帮助"
    else
        do_backup_db
    fi

    ;;
*)
    echo "  参数个数不对"
    ;;
esac

#!/bin/bash

zipfile=$1
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

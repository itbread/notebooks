# psql 连接数据库

psql -U auth_db -h 127.0.0.1 -p 19999

## 备份数据库

pg_dump -h 127.0.0.1 -p 5432 -U postgres -f zzb_db.sql zzb_db

### 备份表

pg_dump -h 127.0.0.1 -p 5432 -U zzb_db -t tp_tmp -f tp_tmp.sql zzb_db

### 还原表

psql -h 127.0.0.1 -p 5432 -U zzb_db -f tp_tmp.sql zzb_db

## 删除数据库、创建用户、授权

drop database zzb_db;
create user zzb_db superuser password '123456';
create database zzb_db owner zzb_db;
grant all on database zzb_db to zzb_db;

## 还原数据库

/Library/PostgreSQL/12/bin/psql -h 127.0.0.1 -U postgres -d zzb_db < ~/Desktop/zzb_db_20200313.bak

drop database zzb_db;
create user zzb_db superuser password '123456';
create database zzb_db owner zzb_db;
grant all on database zzb_db to zzb_db;

drop database auth_db;
create user auth_db superuser password '123456';
create database auth_db owner auth_db;
grant all on database auth_db to auth_db;

## 字符串转时间戳

--日期转时间戳
SELECT EXTRACT(epoch FROM NOW());
--不带时区
SELECT EXTRACT(epoch FROM CAST('2017-12-06 00:17:10' AS TIMESTAMP));
--带时区
SELECT EXTRACT(epoch FROM CAST('2017-12-06 00:17:10' AS TIMESTAMP with time zone));
--时间戳转日期
SELECT TO_TIMESTAMP(1512490630)

--例子 leads_create_dt 是 int8 ,leads_create_time 是字符串
--根据字符串 更新时间戳(转换不带时区)
UPDATE tb_clue_info set leads_create_dt=EXTRACT(epoch FROM CAST(leads_create_time AS TIMESTAMP));

--根据字符串 更新时间戳(转换带时区，如果不带时区时间将会相差 8 个小时)
UPDATE tb_clue_info set leads_create_dt=EXTRACT(epoch FROM CAST(leads_create_time AS TIMESTAMP with time zone)) ;

-- 重复订单中，只查询一条
SELECT DISTINCT ON (uid) uid, order_id FROM tb_order WHERE (tb_order.status=4 ) ORDER BY uid, order_id DESC;

--更新学员投诉记录
update tb_student SET count=num
from
(SELECT student_id, count(student_id) num from tb_record  
GROUP BY student_id) b WHERE tb_student.uid=b.student_id;

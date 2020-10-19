Linux 环境下修改 postgres 密码

```bash
su  postgres
-bash-3.2$ psql -U postgres
postgres=#alter user postgres with password 'new password';
postgres=#\q
```

# psql 连接数据库

psql -U auth_db -h 127.0.0.1 -p 19999

## 备份数据库

pg_dump -h 127.0.0.1 -p 5432 -U postgres -f zzb_db.sql zzb_db
pg_dump -h 47.106.147.83 -p 5432 -U postgres -f auth_db.sql auth_db

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

drop database bds_db;
create user bds_db superuser password '123456';
create database bds_db owner bds_db;
grant all on database bds_db to bds_db;
drop database bds_db;

create user zmp_db superuser password '123456';
create database zmp_db owner zmp_db;
grant all on database zmp_db to zmp_db;

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

--查询学员考试情况（多行转多列）
select tb_student.uid,tb_student.name,tb.\* from tb_student
LEFT JOIN
(
select suid ,
max(case when km=1 and exam_type =1 then exam_result else 0 end) as km1_1,
max(case when km=1 and exam_type =2 then exam_result else 0 end) as km1_2,
max(case when km=1 and exam_type =3 then exam_result else 0 end) as km1_3,
max(case when km=1 and exam_type =4 then exam_result else 0 end) as km1_4,
max(case when km=1 and exam_type =5 then exam_result else 0 end) as km1_5,
max(case when km=2 and exam_type =1 then exam_result else 0 end) as km2_1,
max(case when km=2 and exam_type =2 then exam_result else 0 end) as km2_2,
max(case when km=2 and exam_type =3 then exam_result else 0 end) as km2_3,
max(case when km=2 and exam_type =4 then exam_result else 0 end) as km2_4,
max(case when km=2 and exam_type =5 then exam_result else 0 end) as km2_5,
max(case when km=3 and exam_type =1 then exam_result else 0 end) as km3_1,
max(case when km=3 and exam_type =2 then exam_result else 0 end) as km3_2,
max(case when km=3 and exam_type =3 then exam_result else 0 end) as km3_3,
max(case when km=3 and exam_type =4 then exam_result else 0 end) as km3_4,
max(case when km=3 and exam_type =5 then exam_result else 0 end) as km3_5,
max(case when km=4 and exam_type =1 then exam_result else 0 end) as km4_1,
max(case when km=4 and exam_type =2 then exam_result else 0 end) as km4_2,
max(case when km=4 and exam_type =3 then exam_result else 0 end) as km4_3,
max(case when km=4 and exam_type =4 then exam_result else 0 end) as km4_4,
max(case when km=4 and exam_type =5 then exam_result else 0 end) as km4_5
from tb_exam_record
group by suid
order by suid asc
) tb on tb.suid=tb_student.uid

外键定制三种约束模式
　　 restrict 和 no action:父表更新或者删除时，子表有匹配记录，则禁止父表的更新和删除。默认选项

cascade：父表更新或者删除时，子表有匹配记录，则父表操作成功，同时更新或删除子表匹配项

set null：父表更新或者删除时，子表有匹配记录，则父表操作成功，同时将子表的匹配项设置为 null 值(前提能设置为 null)

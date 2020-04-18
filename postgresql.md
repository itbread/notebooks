# psql连接数据库
psql -U auth_db -h 192.168.0.126 -p 19999

## 备份数据库
pg_dump -h 192.168.0.68 -p 5432 -U postgres -x -s -f zzb_db.sql zzb_db

## 删除数据库、创建用户、授权
drop database zzb_db;
create user zzb_db superuser password '123456';
create database zzb_db owner zzb_db; 
grant all on database zzb_db to zzb_db;
/Library/PostgreSQL/12/bin/psql -h 127.0.0.1 -U postgres -d zzb_db < ~/Desktop/zzb_db_20200313.bak


drop database zzb_db;
create user zzb_db superuser password '123456';
create database zzb_db owner zzb_db; 
grant all on database zzb_db to zzb_db;

drop database auth_db;
create user auth_db superuser password '123456';
create database auth_db owner auth_db; 
grant all on database auth_db to auth_db;
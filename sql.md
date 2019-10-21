# 查询不重复的 attribute_id 记录行
```
select attribute_id,goods_id,title from tb_goods
where goods_id in (select min(goods_id) from tb_goods group by attribute_id)
```

# 查询不重复的 attribute_id 列
```
select distinct attribute_id  from tb_goods
```
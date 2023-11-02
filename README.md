# greenplum_bitmap_bucket
Compact index for billions unique value (like primary key)

## Installation
    $ make install

## Usage
```sql
create extension bitmap_bucket;

create table test (
  id bigint not null,
  val1 integer,
  val2 text
)
with (appendonly=true, orientation=column, compresstype=zstd, compresslevel=2)
distributed by (id);

insert into test (id, val1, val2)
  select i, i*2, 'tst' || i
    from generate_series(1, 500000000) as i;

select pg_size_pretty(pg_relation_size('test'));
-- 2727 MB

explain analyze
select *
  from test
 where id = 100042;
-- ...
-- Execution time: 17714.378 ms

create index pki_test on test
  using bitmap(bitmap_bucket(id));

select pg_size_pretty(pg_total_relation_size('pki_test'));
-- 125 MB

analyze test;

set optimizer = off;

explain analyze
select *
  from test
 where id = 100042 and
       bitmap_bucket(id) = bitmap_bucket(100042)
-- ...
--Execution time: 29.973 ms
```

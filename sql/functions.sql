create or replace function bitmap_bucket(val integer) returns integer as
$$
  select width_bucket(val % 100000000, 0, 100000000, 2000)
$$ language sql immutable;


create or replace function bitmap_bucket(val bigint) returns integer as
$$
  select width_bucket(val % 100000000, 0, 100000000, 2000)
$$ language sql immutable;


create or replace function bitmap_bucket(val anyelement) returns integer as
$$
  select width_bucket(
           coalesce(
             nullif(
               right(regexp_replace(val::text, '\D', '', 'g'), 8),
               ''
             )::float,
             ascii(val::text)::float * 2000
           ), 0, 10^8, 5000
         )
$$ language sql immutable;

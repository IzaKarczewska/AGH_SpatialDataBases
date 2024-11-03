-- zad 1
select * from buildings_2018;
select * from buildings_2019;

select 
	b18.polygon_id
from 
	buildings_2018 b18
join
	buildings_2019 b19 on b18.polygon_id = b19.polygon_id
where 
	st_equals(b18.geom,b19.geom) or
	b18.height <> b19.height;
	
-- weryfikacja czy liczba się zmniejszyła
select count(1) from buildings_2018;

select 
	--count(b18.polygon_id)
	st_buffer(b19.geom, 0.005)
from 
	buildings_2018 b18
join
	buildings_2019 b19 on b18.polygon_id = b19.polygon_id
where 
	st_equals(b18.geom,b19.geom) or
	b18.height <> b19.height;
	
-- Zad 2
select * from poi_2018;
select * from poi_2019;

with renovated as (
	select 
		st_buffer(b19.geom, 0.005) as buffer
	from 
		buildings_2018 b18
	join
		buildings_2019 b19 on b18.polygon_id = b19.polygon_id
	where 
		not st_equals(b18.geom,b19.geom) or
		b18.height <> b19.height
), new_poi as (
	select poi_2019.geom, poi_2019.poi_id, poi_2019.type
	from 
		poi_2019
	where 
		poi_id not in (select poi_id from poi_2018)
)
select
	count(new_poi.poi_id) as poi_count,
	new_poi.type
from
	new_poi
join
    renovated on st_intersects(new_poi.geom, renovated.buffer)
group by 
	new_poi.type;

-- Zad 3
select * from cs_2019;

create table streets_reprojected as
select
	gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel,
	st_setsrid(geom, 3068) as geom
from 
	cs_2019;

select * from streets_reprojected;


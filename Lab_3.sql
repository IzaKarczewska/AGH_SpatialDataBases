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

-- Zad 4
create table input_points (id serial, geometry geometry);
insert into input_points (geometry) values
	('POINT (8.36093 49.03174)'),
	('POINT (8.39876 49.00644)');

select * from input_points;

-- Zad 5
alter table input_points 
alter column geometry type geometry(POINT, 3068)
using st_setsrid(geometry, 3068);

--select UpdateGeometrySRID('input_points','geometry', 3068);
--select * from input_points;

update input_points
set geometry=st_setsrid(geometry,3068);

-- Zad 6
select * from street_2019;
with reprojected as (
	select 
		gid, node_id, link_id, point_num, z_level, "intersect", lat, lon, st_setsrid(geom, 3068) as geom
	from 
		street_2019
), bufor as(
	select st_buffer(st_makeline(geometry), 0.002) as geom
	from input_points
)
select reprojected.*
from reprojected
cross join bufor
where st_contains(bufor.geom, reprojected.geom);

-- Zad 7
select * from poi_2019 where type='Sporting Goods Store';
select * from land_use_a_2019;
with buffer as(
	select st_buffer(geom, 0.003) as geom
	from land_use_a_2019
	where type='Park (City/County)'
)
select count(1)
from poi_2019
cross join buffer
where type='Sporting Goods Store' and st_contains(buffer.geom, poi_2019.geom);

-- Zad 8
create table T2019_KAR_BRIDGES as
select st_intersection(r.geom, w.geom) as geom
from railways_2019 as r
join water_lines_2019 as w on st_intersects(r.geom, w.geom);




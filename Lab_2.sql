-- ZAD 2
create database bdp2_cw;

-- ZAD3
create extension postgis;

-- ZAD 4
create table roads (id int, geometry geometry, name VARCHAR(50));
create table buildings (id serial, geometry geometry, name VARCHAR(50));
create table poi (id serial, geometry geometry, name VARCHAR(50));
select * from roads;

-- ZAD 5
insert into roads (id, geometry, name) values
(1, 'LINESTRING(0 4.5, 12 4.5)', 'RoadX');
insert into roads (id, geometry, name) values
(2, 'LINESTRING(7.5 10.5, 7.5 0)', 'RoadY');

insert into buildings (geometry, name) values
	('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 'BuildingA'),
	('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 'BuildingB'),
	('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
	('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))', 'BuildingD'),
	('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 'BuildingF');
	
insert into poi (geometry, name) values
	('POINT (1 3.5)', 'G'),
	('POINT (5.5 1.5)', 'H'),
	('POINT (9.5 6)', 'I'),
	('POINT (6.5 6)', 'J'),
	('POINT (6 9.5)', 'K');

-- ZAD 6
--a
select sum(st_length(geometry)) as Total_roads_length from roads;

--b
select st_astext(geometry) as wkt, 
st_area(geometry) as area, 
st_perimeter(geometry) as perimeter 
from buildings
where name='BuildingA';

--c
select name, st_area(geometry) as area from buildings
order by name;

--d
select name, st_perimeter(geometry) as perimeter 
from (select st_area(geometry) as area, name, geometry from buildings
		order by area desc
		limit 2) big;
	
-- prościej
select name, st_perimeter(geometry) as perimeter
from buildings
order by st_area(geometry) desc
limit 2;

--e
select st_distance(b.geometry, p.geometry) as distance from buildings b
cross join poi p
where b.name='BuildingC' and p.name='K';

--f
--st_difference(st_buffer(geometry, 0.5))
with bc as(
	select geometry from buildings
	where name='BuildingC'
)
select st_area(st_difference(bc.geometry, st_buffer(b.geometry, 0.5))) from buildings as b, bc 
where name='BuildingB';


--lub
select 
    st_area(st_difference(buildingC.geometry, st_buffer(buildingB.geometry, 0.5)) as area
from buildings as buildingC
cross join buildings as buildingB
where buildingC.name = 'BuildingC' and buildingB.name = 'BuildingB';

--g do poprawy
select st_centroid(b.geometry) as centroid, st_y(st_centroid(b.geometry)) from buildings as b
cross join roads as r
where st_y(st_centroid(b.geometry)) > (select geometry from roads where name='RoadX');

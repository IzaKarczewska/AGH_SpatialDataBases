create database lab5;
-- create extension postgis; tu niepotrzebne

-- ZAD 1
create table obiekty (
    id serial primary KEY,
    nazwa VARCHAR(255) NOT NULL,
    geometria GEOMETRY NOT NULL,
    SRID INT DEFAULT 0
);

--Obiekty dodaję oddzielnie

insert into obiekty(nazwa, geometria) values
	('obiekt1', st_collect(ARRAY[ST_GeomFromText('LINESTRING(0 1, 1 1)'), 
				ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'), 
				ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)'),
				ST_GeomFromText('LINESTRING(5 1, 6 1)')]));
			
insert into obiekty(nazwa, geometria) VALUES
	('obiekt2', st_collect(ARRAY[
	st_GeomFromText('LINESTRING(10 6, 10 2)'),
	st_GeomFromText('CIRCULARSTRING(10 2, 12 0, 14 2)'),
	st_GeomFromText('CIRCULARSTRING(14 2, 16 4, 14 6)'),
	st_GeomFromText('LINESTRING(14 6, 10 6)'),
	st_GeomFromText('CIRCULARSTRING(11 2, 12 1, 13 2, 12 3, 11 2)')]));

select * from obiekty;

insert into obiekty(nazwa, geometria) values
	('obiekt3', ST_GeomFromText('POLYGON((7 15, 12 13, 10 17, 7 15))'));

insert into obiekty(nazwa, geometria) values
	('obiekt4', st_collect(ARRAY[
	st_GeomFromText('LINESTRING(20.5 19.5, 22 19)'),
	st_GeomFromText('LINESTRING(22 19, 26 21)'),
	st_GeomFromText('LINESTRING(26 21, 25 22)'),
	st_GeomFromText('LINESTRING(25 22, 27 24)'),
	st_GeomFromText('LINESTRING(27 24, 25 25)'),
	st_GeomFromText('LINESTRING(25 25, 20 20)')])); -- później zauważyłam że wystarczy użyć jedbego linestringa (przy modyfikacjach do zadania 3 poprawiono)

insert into obiekty(nazwa, geometria) values
	('obiekt5', st_collect(
	st_GeomFromText('POINT(30 30 59)'),
	st_GeomFromText('POINT(38 32 234)')));

insert into obiekty(nazwa, geometria) values
	('obiekt6', st_collect(
	st_GeomFromText('LINESTRING(1 1, 3 2)'),
	st_GeomFromText('POINT(4 2)')));
				
select * from obiekty;

-- ZAD 2
select 
	st_area(st_buffer(st_shortestLine(
		(select geometria from obiekty where nazwa='obiekt3'),
		(select geometria from obiekty where nazwa='obiekt4')), 5))
from obiekty;

-- ZAD 3
-- Poligon musi być  obiektem domkniętym, brakuje nam puktu końcowego takiego samego jak początkowy
update obiekty 
set geometria = st_GeomFromText(st_polygon('LINESTRING(20.5 19.5, 22 19, 26 21, 25 22, 27 24, 25 25, 20 20, 20.5 19.5)'))
where nazwa="obiekt4";

-- ZAD 4
insert into obiekty(nazwa, geometria) values
	('obiekt7', st_collect(
				(select geometria from obiekty where nazwa='obiekt3'),
				(select geometria from obiekty where nazwa='obiekt4')));
			
select * from obiekty

-- ZAD 5
select * from obiekty 
where st_HasArc(geometria) = false; -- wybór obiektów które mają 

select sum(st_area(st_buffer(geometria,5))) as powierzchnia_buforow from obiekty 
where st_HasArc(geometria) = False;





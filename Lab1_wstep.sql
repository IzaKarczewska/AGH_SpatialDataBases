-- ZAD 1
CREATE DATABASE firma;

-- ZAD2
create schema ksiegowosc;

-- ZAD 3
set search_path to ksiegowosc;

create table pracownicy(
	id_pracownika SERIAL primary key,
	imie VARCHAR(50),
	nazwisko VARCHAR(100),
	adres VARCHAR(100),
	telefon VARCHAR(15)
);

comment on table pracownicy is 'Tabela przechowuje dane osobowe i adresowe pracowników firmy';

create table godziny(
	id_godziny SERIAL primary key,
	data DATE,
	liczba_godzin DECIMAL(5,2),
	id_pracownika INT foreign key references pracownicy(id_pracownika)
);

comment on table godziny is 'Tabela przechowuje dane o godzinach pracy pracowników w danych dniu';

create table pensja(
	id_pensji SERIAL primary key,
	stanowisko VARCHAR(50),
	kwota DECIMAL(10,2)
);

comment on table pensja is 'Tabela przechowuje dane o kwocie pensji w zależności od danego stanowiska';

create table premia(
	id_premii SERIAL primary key,
	rodzaj VARCHAR(50),
	kwota DECIMAL(10,2)
);

comment on table premia is 'Tabela przechowuje dane z rodzajami i kwotami premii';

create table wynagrodzenie(
	id_wynagrodzenia SERIAL primary key,
	data DATE,
    id_pracownika INT NOT null references pracownicy(id_pracownika),
    id_godziny INT NOT null references godziny(id_godziny),
    id_pensji INT NOT null references pensja(id_pensji),
    id_premii INT references premia(id_premii)
);

comment on table wynagrodzenie is 'Tabela przechowuje dane o wynagrodzenia pracownikó wykorzystując powiązania do tabel
godziny, pracownicy, pensja, premia';

-- ZAD 4
insert into pracownicy (imie, nazwisko, adres, telefon) values
	('Izabela','Karczewska','ul. Pogodna 14, Białystok', '777 888 999'),
	('Anna	','Nowak','ul. Zmierzchowa 4, Wrocław', '727 881 099'),
	('Jolanta','Jezierska','ul. Wiejska 98a, Kraków', '554829034'),
	('Małgorzata','Karczewska','Czyże 22', '880-770-456'),
	('Karolina','Pogodna','ul. Pogodna 14, Kraków', '888 999 777'),
	('Paweł','Ostawszewski', 'ul. Wodna 2, Kraków', '765 875 955'),
	('Mateusz','Karczewski','ul. Czarnowiejska 87, Kraków', '727 488 999'),
	('Seweryn','Krajewski','Ogrodniki 32', '777 666 111'),
	('Izabela','Kwiatkowska','ul. Dajwór 5, Kraków', '667 888 999'),
	('Edyta','Zielińska','ul. Pogodna 1, Kraków', '765877799');

insert into godziny(data, liczba_godzin, id_pracownika) values
	('11/10/2024', 8, 1);
	('11/10/2024', 8, 1),
	('11/10/2024', 8, 3),
	('11/10/2024', 8, 4),
	('11/10/2024', 7, 5),
	('10/10/2024', 8, 6),
	('2024-10-09', 8, 7),
	('10/10/2024', 8, 1),
	('2024-10-09', 8, 1),
	('2024-10-09', 9, 2);

insert into pensja (stanowisko, kwota) values
	('Programista', 10300.00),
	('Analityk', 7500.00),
	('Kucharz', 6000.00),
	('Kierownik', 23000.00),
	('Architekt', 8000.00),
	('Administrator', 4500.00),
	('DevOps', 9000.00),
	('Fizoterapeuta', 7500.00),
	('Marketing Specialist', 1000.00),
	('Masażysta', 2700.00);

insert into premia (rodzaj, kwota) values
	('Świąteczna', 450.00),
	('Szkolenie', 1500.00),
	('Wyniki', 600.00),
	('Specjalna', 1000.00),
	('Motywacyjna', 8000.00),
	('Bo tak', 200.00),
	('Projekt', 900.00),
	('Rocznicowa', 300.00),
	('Marketingowa', 1000.00),
	('Uczciwość', 700.00);

INSERT INTO wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2024-10-20', 1, 1, 1, 1),
('2024-10-20', 2, 2, 2, 2),
('2024-10-20', 3, 3, 3, 3),
('2024-10-20', 4, 4, 4, 4),
('2024-10-20', 5, 5, 5, 5),
('2024-10-20', 6, 6, 6, 6),
('2024-10-20', 7, 7, 7, 7),
('2024-10-20', 8, 8, 8, 8),
('2024-10-20', 9, 9, 9, 9),
('2024-10-20', 10, 10, 10, 1);

-- ZAD 5
--a
select id_pracownika, nazwisko from pracownicy;

--b
select pr.id_pracownika from pracownicy as pr
join wynagrodzenie as w on pr.id_pracownika = w.id_pracownika
join pensja as pe on pe.id_pensji = w.id_pensji
where pe.kwota >1000;

--c
/*insert into pracownicy (imie, nazwisko, adres, telefon) values
('Marek', 'Nowicki', 'ul. Nowa 11, Kraków', '222-333-444');
insert into wynagrodzenie (data, id_pracownika, id_godziny, id_pensji) values
('2024-10-17', 11, 3, 4);*/
select p.id_pracownika from pracownicy as p
join wynagrodzenie as w on p.id_pracownika = w.id_pracownika
left join premia as pr on pr.id_premii = w.id_premii
join pensja as pe on pe.id_pensji = w.id_pensji
where pe.kwota >2000 and pr.id_premii is NULL;

--d
select * from pracownicy
where imie like('J%');

--e
select * from pracownicy
where imie LIKE('%a') and nazwisko LIKE('%n%');

--f
/*insert into pracownicy (imie, nazwisko, adres, telefon) values
('Damian', 'Nowicki', 'ul. Nowa 11, Kraków', '222-333-444');
insert into godziny (data, liczba_godzin) values
('2024-08-24', 189);
insert into wynagrodzenie (data, id_pracownika, id_godziny, id_pensji) values
('2024-10-17', 12, 11, 1);*/
select pr.imie, pr.nazwisko, g.liczba_godzin from pracownicy as pr
join wynagrodzenie as w on pr.id_pracownika=w.id_pracownika
join godziny as g on g.id_godziny=w.id_godziny
where g.liczba_godzin > 160;

--g
select pr.imie, pr.nazwisko from pracownicy as pr
join wynagrodzenie as w on pr.id_pracownika = w.id_pracownika
join pensja as pe on pe.id_pensji = w.id_pensji
where pe.kwota between 1500.00 and 3000.00;

--h
select * from pracownicy as pr
join wynagrodzenie as w on w.id_pracownika=pr.id_pracownika
join godziny as g on w.id_godziny=g.id_godziny
left join premia as p on w.id_premii=p.id_premii
where g.liczba_godzin>160 and p.id_premii is null;

--i
select pr.imie, pr.nazwisko, pe.kwota, pe.stanowisko from pracownicy as pr
join wynagrodzenie as w on pr.id_pracownika=w.id_pracownika
join pensja as pe on pe.id_pensji=w.id_pensji
order by pe.kwota;

--j
select pr.imie, pr.nazwisko, pe.kwota, coalesce(p.kwota,0) from pracownicy as pr
join wynagrodzenie as w on w.id_pracownika= pr.id_pracownika
join pensja as pe on pe.id_pensji=w.id_pensji
left join premia as p on p.id_premii=w.id_premii
order by pe.kwota desc, p.kwota desc

--k
select pe.stanowisko, count(*) as liczba_pracownikow from pracownicy as p
join wynagrodzenie as w on w.id_pracownika=p.id_pracownika
join pensja as pe on w.id_pensji=pe.id_pensji
group by pe.stanowisko;

--l
--insert into pensja (stanowisko, kwota) values ('Kierownik', 7000.00)
select avg(kwota) as srednia_pensja,
	min(kwota) as minimalna_pensja,
	max(kwota) as maksymalna_pensja
from pensja
where stanowisko='Kierownik';

--m
select sum(kwota) as suma_wynagrodzen
from pensja;

--n (f)
select stanowisko, sum(kwota) as suma_wynagrodzen_na_stanowisku
from pensja
group by stanowisko;

--o (g)
select pe.stanowisko, count(1) as liczba_premii from pracownicy as p
join wynagrodzenie as w on w.id_pracownika=p.id_pracownika
join premia as pr on pr.id_premii=w.id_premii
join pensja as pe on pe.id_pensji=w.id_pensji
group by pe.stanowisko;

--p (h)
delete from pracownicy where id_pracownika in(
	select p.id_pracownika from pracownicy as p
	join wynagrodzenie as w on p.id_pracownika=w.id_pracownika
	join pensja as pe on pe.id_pensji=w.id_pensji
	where pe.kwota<1200);

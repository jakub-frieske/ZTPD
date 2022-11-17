-- Æwiczenia laboratoryjne: Obiektowo-relacyjne bazy danych 

SET SERVEROUTPUT ON;
--1
create type samochod as object(
  MARKA VARCHAR2(20),
  MODEL VARCHAR2(20),
  KILOMETRY NUMBER,
  DATA_PRODUKCJI DATE,
  CENA NUMBER(10,2)
);

-- show
desc samochod

CREATE TABLE samochody
OF samochod;

insert into samochody values(
--  new samochod('FIAT', 'BRAVA', 60000, DATE'1999-11-30', 25000)
-- 	new samochod('FORD', 'MONDEO', 80000, DATE'1997-05-10', 45000)
	new samochod('MAZDA', '323', 12000, DATE'2000-09-22', 52000)
);

--show
 select * from samochody;
 
 
--2
create table wlasciciele(
  IMIE VARCHAR2(100),
  NAZWISKO VARCHAR2(100),
  AUTO SAMOCHOD
)

--show
desc wlasciciele

insert into wlasciciele values
--  ('JAN ', 'KOWALSKI', new samochod('FIAT', 'SEICENTO', 30000, DATE'0010-12-02', 19500))
  ('ADAM ', 'NOWAK', new samochod('OPEL', 'ASTRA', 34000, DATE'0009-06-01', 33700))
;
   
--show
select * from wlasciciele;
	
    							  
--3
alter type samochod add member function wartosc return number cascade;
CREATE OR REPLACE TYPE BODY samochod AS
 MEMBER FUNCTION wartosc RETURN NUMBER IS
 BEGIN
   RETURN cena * power(0.9, (EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM data_produkcji)) );
  END wartosc;
END;

desc samochod;
--show
SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

																  
--4
ALTER TYPE samochod ADD 
MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
 MEMBER FUNCTION wartosc RETURN NUMBER IS
 BEGIN
   RETURN cena * power(0.9, (EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM data_produkcji)) );
  END wartosc;
 MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
 BEGIN
   RETURN EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM data_produkcji) + kilometry/10000 ;
  END odwzoruj;
END;

--show
SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);


--5
create type wlasciciel as object(
    imie varchar(100),
    nazwisko varchar(100)
)

alter type samochod add attribute posiadacz ref wlasciciel cascade;

create table Wlasciciele_2 of wlasciciel;
create table Samochody_2 of samochod;
insert into wlasciciele_2 values(new wlasciciel('Jan', 'Wolny'));
select * from wlasciciele_2;
select * from Samochody_2;

insert into samochody_2 values(NEW samochod('OPEL', 'ASTRA', 34000, '0009-06-01', 33700, null));
UPDATE Samochody_2 s SET s.posiadacz = (SELECT REF(w) FROM Wlasciciele_2 w WHERE w.imie = 'Jan' );


--6
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
     moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;


--7
declare 
    type t_ksiazki is varray(10) of varchar(100);
    lista_ksiazek t_ksiazki := t_ksiazki('');
begin
    lista_ksiazek(1) := 'Harry Potter';
    lista_ksiazek.extend(2);
    lista_ksiazek(2) := 'Tytul 2';
    lista_ksiazek(3) := 'Tytul 3';
    FOR i IN lista_ksiazek.first()..lista_ksiazek.last() LOOP 
        dbms_output.put_line(i || lista_ksiazek(i));
    END LOOP;
    
    lista_ksiazek.trim(2);
    FOR i IN lista_ksiazek.first()..lista_ksiazek.last() LOOP 
        dbms_output.put_line(lista_ksiazek(i));
    END LOOP;
end;


--8
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
    moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    IF moi_wykladowcy.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END IF;
 END LOOP;
 
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    IF moi_wykladowcy.EXISTS(i) THEN
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;


--9
declare
  type t_miesiace is table of varchar(20);
  miesiace t_miesiace := t_miesiace();
begin
 miesiace.extend(12);
 for i in 1..12 loop
    miesiace(i) := to_char(to_date(i,'MM'), 'Month');
 end loop;
 miesiace.delete(5,7);
 FOR i IN miesiace.first()..miesiace.last() LOOP 
   IF miesiace.EXISTS(i) THEN
        dbms_output.put_line(i || ' ' ||miesiace(i));
    END IF;
 END LOOP;
end;


--10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';


--11
CREATE TYPE produkty AS TABLE OF VARCHAR2(50);

CREATE TYPE zakup AS OBJECT (
 numer NUMBER,
 KOSZYK_PRODUKTOW produkty);
 
CREATE TABLE zakupy OF zakup
NESTED TABLE KOSZYK_PRODUKTOW STORE AS tab_koszyk_produktow;

INSERT INTO zakupy VALUES (1, produkty('CHLEB', 'MASLO'));
INSERT INTO zakupy VALUES (2, produkty('PIWO', 'PIELUSZKI'));
INSERT INTO zakupy VALUES (3, produkty('PIELUSZKI', 'PLATKI'));

--show
SELECT z.numer, e.*
FROM zakupy z, TABLE(z.KOSZYK_PRODUKTOW) e;

DELETE FROM zakupy
where 
    numer in
    (   
        SELECT z.numer
        FROM zakupy z, TABLE (z.KOSZYK_PRODUKTOW) p
        WHERE p.column_value = 'PIELUSZKI'
    );

--show
SELECT z.numer, e.*
FROM zakupy z, TABLE(z.KOSZYK_PRODUKTOW) e;


--12
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

--13
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 --InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;


--14
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

--15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;


--16
drop table PRACOWNICY;
CREATE TABLE PRZEDMIOTY_2(
 NAZWA VARCHAR2(50),
 NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

--17
CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);


--18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

--19
CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);
/
CREATE TYPE PRACOWNIK AS OBJECT (
 ID_PRAC NUMBER,
 NAZWISKO VARCHAR2(30),
 ETAT VARCHAR2(20),
 ZATRUDNIONY DATE,
 PLACA_POD NUMBER(10,2),
 MIEJSCE_PRACY REF ZESPOL,
 PRZEDMIOTY PRZEDMIOTY_TAB,
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY PRACOWNIK AS
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
 BEGIN
 RETURN PRZEDMIOTY.COUNT();
 END ILE_PRZEDMIOTOW;
END;

--20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
 MAKE_REF(ZESPOLY_V,ID_ZESP),
 CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

--21
SELECT *
FROM PRACOWNICY_V;
SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;
SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;
SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );
SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;


--22
CREATE TABLE PISARZE (
 ID_PISARZA NUMBER PRIMARY KEY,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE );
CREATE TABLE KSIAZKI (
 ID_KSIAZKI NUMBER PRIMARY KEY,
 ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
 TYTUL VARCHAR2(50),
 DATA_WYDANIE DATE );
INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(10,10,'OGNIEM I MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(30,10,'PAN WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');

---
create type t_ksiazki as table of varchar2(100);
create type pisarz  as object (
 ID_PISARZA NUMBER,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE,
 ksiazki t_ksiazki,
 member function lb_ksiazek return number
);
CREATE OR REPLACE TYPE BODY pisarz AS
 MEMBER FUNCTION lb_ksiazek RETURN NUMBER IS
 BEGIN
   RETURN ksiazki.count();
  END lb_ksiazek;
END;

CREATE or replace type ksiazka as object (
 ID_KSIAZKI NUMBER,
 autor ref pisarz,
 TYTUL VARCHAR2(20),
 data_wydania DATE,
 member function wiek return number
);
CREATE OR REPLACE TYPE BODY ksiazka AS
 MEMBER FUNCTION wiek RETURN NUMBER IS
 BEGIN
   RETURN extract(YEAR FROM current_date) - extract(YEAR FROM data_wydania);
  END wiek;
END;

CREATE OR REPLACE VIEW v_pisarze OF pisarz
WITH OBJECT IDENTIFIER(id_pisarza)
AS SELECT id_pisarza, nazwisko, data_ur, CAST(MULTISET( SELECT TYTUL FROM KSIAZKI WHERE ID_PISARZA=P.ID_PISARZA ) as t_ksiazki)  FROM pisarze p;

ALTER TABLE ksiazki
RENAME COLUMN data_wydanie TO data_wydania;
CREATE OR REPLACE VIEW v_ksiazki OF ksiazka
WITH OBJECT IDENTIFIER(id_ksiazki)
AS SELECT id_ksiazki, make_ref(v_pisarze,id_pisarza), tytul, data_wydania FROM ksiazki;

select * from v_pisarze;


--23
CREATE TYPE AUTO AS OBJECT (
 MARKA VARCHAR2(20),
 MODEL VARCHAR2(20),
 KILOMETRY NUMBER,
 DATA_PRODUKCJI DATE,
 CENA NUMBER(10,2),
 MEMBER FUNCTION WARTOSC RETURN NUMBER
) NOT FINAL;
CREATE OR REPLACE TYPE BODY AUTO AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WIEK NUMBER;
 WARTOSC NUMBER;
 BEGIN
 WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
 WARTOSC := CENA - (WIEK * 0.1 * CENA);
 IF (WARTOSC < 0) THEN
 WARTOSC := 0;
 END IF;
 RETURN WARTOSC;
 END WARTOSC;
END;
CREATE TABLE AUTA OF AUTO;
INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));

select * from auta;
---
create or replace type auto_osobowe under auto (
    liczba_miejsc number,
    czy_klimatyzacja varchar2(3),
    OVERRIDING  MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY auto_osobowe AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
     WARTOSC NUMBER;
 BEGIN
    wartosc := (SELF AS AUTO).wartosc();
     IF (czy_klimatyzacja = 'TAK' ) THEN
            wartosc := wartosc * 1.5;
    END IF;
    RETURN wartosc;
 END WARTOSC;
END;
create type auto_ciezarowe under auto(
    maks_ladownosc number,
    OVERRIDING  MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY auto_ciezarowe AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
     WARTOSC NUMBER;
 BEGIN
    wartosc := (SELF AS AUTO).wartosc();
    IF (maks_ladownosc > 10000) THEN
            wartosc := wartosc * 2;
    END IF;
    RETURN wartosc;
 END WARTOSC;
END;

INSERT INTO AUTA VALUES (auto_osobowe('Marka1','Typ1',60000,DATE '2017-11-30',25000,5,'TAK'));
INSERT INTO AUTA VALUES (auto_osobowe('Marka2','Typ2',80000,DATE '2015-05-10',45000,5,'NIE'));
INSERT INTO AUTA VALUES (auto_ciezarowe('Marka3','Typ3',12000,DATE '2019-09-22',52000,8000));
INSERT INTO AUTA VALUES (auto_ciezarowe('Marka4','Typ4',12000,DATE '2020-09-22',52000,12000));

SELECT a.marka, a.wartosc() FROM auta a;

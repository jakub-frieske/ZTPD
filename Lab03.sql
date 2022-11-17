--  Æwiczenia laboratoryjne: Du¿e obiekty tekstowe

--1
create table DOKUMENTY(
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

--2
declare 
    text clob;
begin
    for i in 1..1000 loop
        text := concat(text, 'Oto tekst ');
    end loop;
    
    insert into DOKUMENTY values(1, text);
end;

--3
--a
select * from dokumenty;
--b
select upper(DOKUMENT) from dokumenty;
--c
select LENGTH(DOKUMENT) from dokumenty;
--d
select DBMS_LOB.GETLENGTH(DOKUMENT) from dokumenty;
--e
select SUBSTR(DOKUMENT, 5, 1000) from dokumenty;
--f
select DBMS_LOB.SUBSTR(DOKUMENT, 5, 1000) from dokumenty;

--4
insert into dokumenty values (2,EMPTY_CLOB());

--5
insert into dokumenty values (3,NULL); commit;

--6 j.w.
--7
select * from all_directories;

--8
SET SERVEROUTPUT ON;

DECLARE
    lobd clob;
    fils BFILE := BFILENAME('ZSBD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT dokument INTO lobd FROM dokumenty
    WHERE id=2 FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE,
    doffset, soffset, 0, langctx, warn);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--9
update dokumenty
set dokument = TO_CLOB(bfilename('ZSBD_DIR','dokument.txt'))
where id =3;

--10
select * from dokumenty;

--11
select DBMS_LOB.GETLENGTH(dokument) from dokumenty;

--12
drop table dokumenty;

--13
CREATE OR REPLACE Procedure CLOB_CENSOR(
    lobd IN OUT clob, 
    pattern VARCHAR2
)
is
    pos integer;
    text varchar2(100);
begin
    for i in 1..length(pattern) loop
        text := concat(text, '.');
    end loop;
    
    loop
        pos := DBMS_LOB.instr(lobd, pattern, 1, 1);
        exit when pos=0;
        DBMS_LOB.write(lobd,length(pattern),pos,text);
    end loop;
end CLOB_CENSOR;

--14
create table my_bio as
select * 
from  ZSBD_TOOLS.BIOGRAPHIES;

declare 
    lobd clob;
begin
    SELECT bio INTO lobd FROM my_bio
    WHERE id = 1 FOR UPDATE;
    
    CLOB_CENSOR(lobd, 'Cimrman');
    COMMIT;
end;

select * from my_bio;

--15
drop table my_bio;

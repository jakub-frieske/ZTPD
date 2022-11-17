--  Du¿e obiekty binarne

--1
create table MOVIES
(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);

--2
insert into MOVIES 
select 
    d.ID, 
    d.TITLE, 
    d.category, 
    TRIM(d.year), 
    d.cast, 
    d.director, 
    d.story, 
    d.price,
    c.IMAGE,
    c.MIME_TYPE
from DESCRIPTIONS d
full outer join COVERS c
on d.ID = c.MOVIE_ID;
--3
select ID, title 
from movies 
where COVER is null;
--4
select ID, title, length(cover) as FILESIZE 
from movies 
where COVER is not null;
--5
select ID, title, length(cover)  as FILESIZE 
from movies 
where COVER is  null;
--6
select * 
from ALL_DIRECTORIES;
--7
update movies
set
    COVER = EMPTY_BLOB(),
    MIME_TYPE = 'image/jpeg'
where ID = 66;
--8
select ID, title, DBMS_LOB.GETLENGTH(cover) 
from movies 
where ID in (65,66);
--9
DECLARE
     lobd blob;
     fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
     SELECT cover into lobd from movies
     where id = 66
     FOR UPDATE;
     
     DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
     DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
     DBMS_LOB.FILECLOSE(fils);
     
     COMMIT;
END;
--10
CREATE TABLE TEMP_COVERS
(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);
--11
INSERT INTO temp_covers 
VALUES(65, BFILENAME('ZSBD_DIR','eagles.jpg'),'image/jpeg');
COMMIT;
--12
select movie_id, DBMS_LOB.GETLENGTH(image) 
from temp_covers
--13
DECLARE
     mime VARCHAR2(50);
     image BFILE;
     lobd blob;
BEGIN
    
    SELECT image, mime_type into image, mime from temp_covers
    where id=65;
    
    dbms_lob.createtemporary(lobd, TRUE);
    
    DBMS_LOB.fileopen(image, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, image, DBMS_LOB.GETLENGTH(image));
    DBMS_LOB.FILECLOSE(image);
    
    update movies
    set cover = lobd,
    mime_type = mime
    where id = 65;
    
    dbms_lob.freetemporary(lobd);
    COMMIT;
END;
--14
select id, dbms_lob.getlength(cover) from movies
where id in (65,66);
--15
drop table movies;
drop table temp_covers;
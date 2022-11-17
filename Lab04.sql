-- Æwiczenia laboratoryjne: Wprowadzenie, typ SDO_GEOMETRY

--1A
create table figury(
 id number(1) primary key,
 ksztalt MDSYS.SDO_GEOMETRY
);

--1B
insert into figury values(
    1,
    MDSYS.SDO_GEOMETRY(
        2003,
        null,
        null,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        MDSYS.SDO_ORDINATE_ARRAY(3,5, 5,7, 7,5)
    
    )
);
insert into figury values(
    2,
    MDSYS.SDO_GEOMETRY(
        2003,
        null,
        null,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 3),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    
    )
);  
insert into figury values(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        null,
        null,
        MDSYS.SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
        MDSYS.SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1)    
    )
); 
-- 1C
insert into figury values(
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        null,
        null,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        MDSYS.SDO_ORDINATE_ARRAY(1,5,1,7,1,9)
    )
);

-- 1D
select ID, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) VALID from figury;

-- 1E
delete from figury
where SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) != 'TRUE';

commit;
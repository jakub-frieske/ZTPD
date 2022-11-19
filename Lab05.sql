-- Æwiczenia laboratoryjne: Przetwarzanie danych przestrzennych (Metadane, indeksowanie, przetwarzanie)
SELECT * FROM USER_SDO_GEOM_METADATA;

-- 1A
INSERT INTO USER_SDO_GEOM_METADATA
    VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
    MDSYS.SDO_DIM_ELEMENT('X', 0, 20, 0.01),
    MDSYS.SDO_DIM_ELEMENT('Y', 0, 20, 0.01) ),
    NULL 
);

-- 1B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0)
FROM dual;

-- 1C
CREATE INDEX FIGURY_IDX
ON FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- 1D
SELECT id
FROM figury
WHERE SDO_FILTER(KSZTALT, SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null)) = 'TRUE';
 
-- 1E
SELECT id
FROM figury
WHERE SDO_RELATE(
ksztalt, 
SDO_GEOMETRY(
2001,null,SDO_POINT_TYPE(3,3,null),null,null), 
'mask=ANYINTERACT') = 'TRUE';
 
 
-- 2A
select A.CITY_NAME MIASTO, SDO_NN_DISTANCE(1) ODL
from MAJOR_CITIES A
where  SDO_NN(GEOM,
    (
        select geom 
        from major_cities
        where city_name = 'Warsaw'
    ),
    'sdo_num_res=10 unit=km',1) = 'TRUE' and A.CITY_NAME != 'Warsaw' ;
    
-- 2B
select A.CITY_NAME MIASTO
from MAJOR_CITIES A
where  SDO_WITHIN_DISTANCE(GEOM,
    (
        select geom 
        from major_cities
        where city_name = 'Warsaw'
    ),'distance=100 unit=km') = 'TRUE' and A.CITY_NAME != 'Warsaw' ;
    
-- 2C
select B.CNTRY_NAME, c.CITY_NAME Miasto
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where SDO_RELATE(C.GEOM, B.GEOM, 'mask=INSIDE') = 'TRUE' 
 and B.CNTRY_NAME = 'Slovakia';

-- 2D
select B.CNTRY_NAME, SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km') ODL
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where SDO_RELATE(A.GEOM, B.GEOM,'mask=ANYINTERACT') != 'TRUE' 
    and  A.CNTRY_NAME = 'Poland';

-- 3A
select A.CNTRY_NAME, ROUND(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km'))  ODL
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' and SDO_FILTER(A.GEOM, B.GEOM) = 'TRUE';

-- 3B
select CNTRY_NAME from (
    select A.CNTRY_NAME, SDO_GEOM.sdo_area(A.GEOM, 1, 'unit=SQ_KM')
    from COUNTRY_BOUNDARIES A 
    order by 2 desc
)
where rownum=1;

-- 3C
select SDO_GEOM.sdo_area(SDO_AGGR_MBR(GEOM), 1, 'unit=SQ_KM'))
from MAJOR_CITIES
where CITY_NAME in ('Lodz', 'Warsaw');

-- 3D
select SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1).GET_GTYPE()
from COUNTRY_BOUNDARIES A, MAJOR_CITIES B
where A.CNTRY_NAME = 'Poland'
and B.CITY_NAME = 'Prague';

-- 3E
select CITY_NAME,CNTRY_NAME from 
(select a.CITY_NAME, b.CNTRY_NAME,
 SDO_GEOM.SDO_DISTANCE(a.GEOM,SDO_GEOM.SDO_CENTROID(b.geom,1),1, 'unit=km')
from COUNTRY_BOUNDARIES B, MAJOR_CITIES A
order by 3) 
where rownum =1;

-- 3F
select r.NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(R.GEOM, B.GEOM, 1), 1, 'unit=km') dlugosc
from RIVERS R, COUNTRY_BOUNDARIES B
where B.CNTRY_NAME = 'Poland' and 
      SDO_RELATE(R.geom, B.GEOM, 'mask=OVERLAPBDYINTERSECT') = 'TRUE';

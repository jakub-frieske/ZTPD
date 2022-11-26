-- Æwiczenia laboratoryjne: Przetwarzanie danych przestrzennych SQL/MM

-- 1A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' 
(FINAL:'||t.final||', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

-- 1B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- 1C
create table MYST_MAJOR_CITIES(
    FIPS_CNTRY VARCHAR2(2),
    CITY_NAME VARCHAR2(40),
    STGEOM ST_POINT
);

-- 1D
insert into MYST_MAJOR_CITIES 
select 
    FIPS_CNTRY, 
    CITY_NAME,
    TREAT(ST_POINT.FROM_SDO_GEOM(C.GEOM) AS ST_POINT) STGEOM
from MAJOR_CITIES;

-- 2A
insert into MYST_MAJOR_CITIES 
values (
    'PL', 
    'Szczyrk', 
    TREAT(ST_POINT.FROM_WKT('POINT(19.036107 49.718655)') AS ST_POINT)
);

-- 2B
select name, r.geom.GET_WKT() WKT
from RIVERS r;

-- 2C
select SDO_UTIL.TO_GMLGEOMETRY(c.stgeom.GET_SDO_GEOM())
from MYST_MAJOR_CITIES c
where CITY_NAME = 'Szczyrk';

-- 3A
create table MYST_COUNTRY_BOUNDARIES(
    FIPS_CNTRY VARCHAR2(2),
    CNTRY_NAME VARCHAR2(40),
    STGEOM ST_MULTIPOLYGON
);

-- 3B
insert into MYST_COUNTRY_BOUNDARIES
select FIPS_CNTRY, CNTRY_NAME, ST_MULTIPOLYGON(GEOM)
from COUNTRY_BOUNDARIES;

-- 3C
select b.STGEOM.ST_GEOMETRYTYPE(), count(*) 
from MYST_COUNTRY_BOUNDARIES b
group by b.STGEOM.ST_GEOMETRYTYPE();

-- 3D
select b.STGEOM.ST_ISSIMPLE()
from MYST_COUNTRY_BOUNDARIES b;

-- 4A
select B.CNTRY_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where b.STGEOM.ST_Contains(c.STGEOM) = 1 
    and city_name != 'Szczyrk'
group by B.CNTRY_NAME;


-- 4B
select b.cntry_name a_name, b2.cntry_name b_name
from MYST_COUNTRY_BOUNDARIES B, MYST_COUNTRY_BOUNDARIES B2
where b.STGEOM.st_touches(b2.STGEOM) = 1 
    and b2.CNTRY_NAME = 'Czech Republic';
    
-- 4C
select distinct b.cntry_name,  r.name
from MYST_COUNTRY_BOUNDARIES B, rivers r
where ST_LINESTRING(r.GEOM).ST_Intersects(b.STGEOM) = 1 
    and b.CNTRY_NAME = 'Czech Republic';
    
-- 4D
select TREAT(b.stgeom.st_union(b2.stgeom) AS ST_POLYGON).ST_AREA() POWIERZCHNIA
from MYST_COUNTRY_BOUNDARIES B, MYST_COUNTRY_BOUNDARIES B2
where b.CNTRY_NAME = 'Slovakia'
    and b2.CNTRY_NAME = 'Czech Republic';

-- 4E
select B.STGEOM OBIEKT,
 B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GEOMETRYTYPE() WEGRY_BEZ
from MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
and W.name = 'Balaton';

-- 5A
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME; 

EXPLAIN PLAN FOR
select count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select plan_table_output from table(dbms_xplan.display('plan_table',null,'basic'));

-- 5B
insert into USER_SDO_GEOM_METADATA
 select 'MYST_MAJOR_CITIES', 'STGEOM', T.DIMINFO, T.SRID
 from ALL_SDO_GEOM_METADATA  T
 where T.TABLE_NAME = 'MAJOR_CITIES';

-- 5C
create index MYST_MAJOR_CITIES_IDX on
 MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;

-- 5D
SELECT A.CNTRY_NAME AS A_NAME, COUNT(*)
FROM MYST_COUNTRY_BOUNDARIES A, MYST_MAJOR_CITIES B
WHERE SDO_WITHIN_DISTANCE(B.STGEOM, A.STGEOM, 'distance=100 unit=km') = 'TRUE' AND A.CNTRY_NAME = 'Poland'
GROUP BY A.CNTRY_NAME;

EXPLAIN PLAN FOR
SELECT A.CNTRY_NAME AS A_NAME, COUNT(*)
FROM MYST_COUNTRY_BOUNDARIES A, MYST_MAJOR_CITIES B
WHERE SDO_WITHIN_DISTANCE(B.STGEOM, A.STGEOM, 'distance=100 unit=km') = 'TRUE' AND A.CNTRY_NAME = 'Poland'
GROUP BY A.CNTRY_NAME;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY);
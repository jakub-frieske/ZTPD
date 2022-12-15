-- 1
--- A
create table A6_LRS(
GEOM SDO_GEOMETRY
);

--- B
INSERT INTO a6_lrs
select SDO_LRS.CONVERT_TO_LRS_GEOM(SR.GEOM, 0, 276.681)
from STREETS_AND_RAILROADS SR, MAJOR_CITIES C
where SDO_RELATE(SR.GEOM,
     SDO_GEOM.SDO_BUFFER(C.GEOM, 10, 1, 'unit=km'),
    'MASK=ANYINTERACT') = 'TRUE'
and C.CITY_NAME = 'Koszalin';

--- C
select ST_LINESTRING(GEOM) .ST_NUMPOINTS() ST_NUMPOINTS
from A6_LRS;

--- D
UPDATE a6_lrs
SET GEOM = SDO_LRS.CONVERT_TO_LRS_GEOM(
    GEOM, 0,
    SDO_GEOM.SDO_LENGTH(GEOM, 1, 'unit=km'));

--- E
INSERT INTO USER_SDO_GEOM_METADATA
VALUES ('A6_LRS','GEOM',
MDSYS.SDO_DIM_ARRAY(
 MDSYS.SDO_DIM_ELEMENT('X', 12.603676, 26.369824, 1),
 MDSYS.SDO_DIM_ELEMENT('Y', 45.8464, 58.0213, 1),
 MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 1) ),
 8307
);
 
--- F
CREATE INDEX A6_LRS_IDX ON A6_LRS(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- 2
--- A
select SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500
from A6_LRS;

--- B
select SDO_LRS.GEOM_SEGMENT_END_PT(GEOM) END_PT
from A6_LRS;

--- C
select SDO_LRS.LOCATE_PT(GEOM, 150, 0) KM150 
from A6_LRS;

--- D
select SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160) CLIPED 
from A6_LRS;

--- E
select SDO_LRS.GET_NEXT_SHAPE_PT(A6.GEOM,
    SDO_LRS.PROJECT_PT(A6.GEOM, C.GEOM)) WJAZD_NA_A6
from A6_LRS A6, MAJOR_CITIES C where C.CITY_NAME = 'Slupsk';

--- F
select SDO_GEOM.SDO_LENGTH(
    SDO_LRS.OFFSET_GEOM_SEGMENT(A6.GEOM, M.DIMINFO, 50, 200, 50,
    'unit=m arc_tolerance=0.05'),
    1, 'unit=km'
    )
    KOSZT
from A6_LRS A6, USER_SDO_GEOM_METADATA M
where M.TABLE_NAME = 'A6_LRS' and M.COLUMN_NAME = 'GEOM';
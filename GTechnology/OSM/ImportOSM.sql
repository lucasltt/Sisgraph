SET ECHO ON;
SPOOL IMPORTING_GTECH.LOG;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------DELETANDO REGISTROS DUPLICADOS-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM
       GIS_OSM_NATURAL_A_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_NATURAL_A_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID 
             );
COMMIT;

DELETE FROM
       GIS_OSM_BUILDINGS_A_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_BUILDINGS_A_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID
             );
COMMIT;    

DELETE FROM
       GIS_OSM_LANDUSE_A_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_LANDUSE_A_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID 
             );
COMMIT;

DELETE FROM
       GIS_OSM_PLACES_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_PLACES_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID 
             );
COMMIT;

DELETE FROM
       GIS_OSM_RAILWAYS_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_RAILWAYS_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID 
             );
COMMIT;

DELETE FROM
       GIS_OSM_WATERWAYS_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_WATERWAYS_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID 
             );
COMMIT;

DELETE FROM
       GIS_OSM_ROADS_FREE_1 A
WHERE
       ROWID > (
             SELECT MIN(ROWID)
             FROM
             GIS_OSM_ROADS_FREE_1 B      
             WHERE
             A.OSM_ID = B.OSM_ID 
             );
COMMIT;
              

------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------BUILDING-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO GC_BUILDING
  SELECT GC_BUILDING_SEQ.NEXTVAL,
         21400,
         21401,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME
    FROM GIS_OSM_BUILDINGS_A_FREE_1 B WHERE B.NAME IS NOT NULL;
    COMMIT;
  
INSERT INTO GC_BUILDING_P
  SELECT G.G3E_ID, 21400, 21410, G.G3E_FID, 1, B.TYPE, B.GEOMETRY
    FROM GC_BUILDING G, GIS_OSM_BUILDINGS_A_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID;
COMMIT;  


------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------NATURAL-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO GC_NATURAL
  SELECT GC_NATURAL_SEQ.NEXTVAL,
         21600,
         21601,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME
    FROM GIS_OSM_NATURAL_A_FREE_1 B WHERE B.NAME IS NOT NULL;
COMMIT;
    
INSERT INTO GC_NATURAL_P
  SELECT G.G3E_ID, 21600, 21610, G.G3E_FID, 1, B.FCLASS, B.GEOMETRY
    FROM GC_NATURAL G, GIS_OSM_NATURAL_A_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID;
COMMIT;


------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------LANDUSE-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO GC_LANDUSE
  SELECT GC_LANDUSE_SEQ.NEXTVAL,
         21500,
         21501,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME
    FROM GIS_OSM_LANDUSE_A_FREE_1 B WHERE B.NAME IS NOT NULL;
COMMIT;

INSERT INTO GC_LANDUSE_P
  SELECT G.G3E_ID, 21500, 21510, G.G3E_FID, 1, B.FCLASS, B.GEOMETRY
    FROM GC_LANDUSE G, GIS_OSM_LANDUSE_A_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID;
COMMIT;



------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------PLACES-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO GC_PLACES
  SELECT GC_PLACES_SEQ.NEXTVAL,
         21300,
         21301,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME,
         B.POPULATION
    FROM GIS_OSM_PLACES_FREE_1 B WHERE B.NAME IS NOT NULL;
COMMIT;

INSERT INTO GC_PLACES_S
  SELECT G.G3E_ID, 21300, 21310, G.G3E_FID, 1, B.GEOMETRY
    FROM GC_PLACES G, GIS_OSM_PLACES_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID AND B.NAME IS NOT NULL;
COMMIT;

INSERT INTO GC_PLACES_T
  SELECT GC_PLACES_S_SEQ.NEXTVAL,
         21300,
         21330,
         S.G3E_FID,
         1,
         S.G3E_GEOMETRY,
         8,
         NULL,
         P.FCLASS
    FROM GC_PLACES_S S, GC_PLACES GC, GIS_OSM_PLACES_FREE_1 P
   WHERE S.G3E_FID = GC.G3E_FID
     AND GC.OSM_ID = P.OSM_ID;
   
   COMMIT;


------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------RAILWAYS-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO GC_RAILWAYS
  SELECT GC_RAILWAYS_SEQ.NEXTVAL,
         21100,
         21101,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME
    FROM GIS_OSM_RAILWAYS_FREE_1 B WHERE B.NAME IS NOT NULL;
COMMIT;

INSERT INTO GC_RAILWAYS_L
  SELECT G.G3E_ID, 21100, 21110, G.G3E_FID, 1, B.FCLASS, B.GEOMETRY
    FROM GC_RAILWAYS G, GIS_OSM_RAILWAYS_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID;
COMMIT;


------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------WATERWAYS-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO GC_WATERWAYS
  SELECT GC_WATERWAYS_SEQ.NEXTVAL,
         21200,
         21201,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME,
         B.WIDTH
    FROM GIS_OSM_WATERWAYS_FREE_1 B WHERE B.NAME IS NOT NULL;
COMMIT;

INSERT INTO GC_WATERWAYS_L
  SELECT G.G3E_ID, 21200, 21210, G.G3E_FID, 1, B.FCLASS, B.GEOMETRY
    FROM GC_WATERWAYS G, GIS_OSM_WATERWAYS_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID;
COMMIT;


------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------ROAD-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM GIS_OSM_ROADS_FREE_1

INSERT INTO GC_ROAD
  SELECT GC_ROAD_SEQ.NEXTVAL,
         21000,
         21001,
         G3E_FID_SEQ.NEXTVAL,
         1,
         B.OSM_ID,
         B.NAME,
         B.Ref,
         B.FCLASS,
         DECODE(B.Oneway,'F', 0, 1),
         B.Maxspeed
    FROM GIS_OSM_ROADS_FREE_1 B WHERE B.NAME IS NOT NULL;
COMMIT;

INSERT INTO GC_ROAD_L
  SELECT G.G3E_ID, 21000, 21010, G.G3E_FID, 1,
  CaSE
    WHEN B.BRIDGE = 'T' ThEn 'Bridge'
    WhEN B.TUNNEL = 'T' THeN 'Tunel'
    ElSE 'Road'
      EnD,
   B.GEOMETRY
    FROM GC_ROAD G, GIS_OSM_ROADS_FREE_1 B
   WHERE G.OSM_ID = B.OSM_ID;
COMMIT;


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------UPDATE CHARSET UTF-8 PARA ISO-8859-1------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE GC_ROAD SET NAME_ROAD = CONVERT(NAME_ROAD, 'WE8MSWIN1252', 'AL32UTF8');
COMMIT;


UPDATE GC_RAILWAYS SET NAME_RAILWAYS = CONVERT(NAME_RAILWAYS, 'WE8MSWIN1252', 'AL32UTF8');
COMMIT;

UPDATE GC_WATERWAYS SET NAME_WATERWAYS = CONVERT(NAME_WATERWAYS, 'WE8MSWIN1252', 'AL32UTF8');
COMMIT;


UPDATE GC_PLACES SET NAME_PLACES = CONVERT(NAME_PLACES,  'WE8MSWIN1252', 'AL32UTF8');
COMMIT;


UPDATE GC_BUILDING SET NAME_BUILDING = CONVERT(NAME_BUILDING, 'WE8MSWIN1252', 'AL32UTF8');
COMMIT;

UPDATE GC_LANDUSE SET NAME_LANDUSE = CONVERT(NAME_LANDUSE, 'WE8MSWIN1252', 'AL32UTF8');
COMMIT;

UPDATE GC_NATURAL SET NAME_NATURAL = CONVERT(NAME_NATURAL, 'WE8MSWIN1252', 'AL32UTF8');
COMMIT;

SPOOL OFF;
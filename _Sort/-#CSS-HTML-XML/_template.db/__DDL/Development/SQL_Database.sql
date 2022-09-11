SELECT FIRST 10 * FROM RDB$FIELDS; 
SELECT FIRST 10 * FROM RDB$TYPES; 
SELECT FIRST 10 * FROM RDB$RELATIONS; 
SELECT FIRST 10 * FROM RDB$RELATION_FIELDS;

SELECT F.RDB$FIELD_NAME,      F.RDB$FIELD_TYPE,  F.RDB$FIELD_SUB_TYPE, 
       F.RDB$FIELD_LENGTH,    F.RDB$FIELD_SCALE, F.RDB$DEFAULT_VALUE, 
       F.RDB$FIELD_PRECISION, FT.RDB$TYPE_NAME,  FST.RDB$TYPE_NAME
FROM RDB$FIELDS F, RDB$TYPES FT LEFT OUTER JOIN RDB$TYPES FST
 ON (FST.RDB$FIELD_NAME = 'RDB$FIELD_SUB_TYPE'
  AND F.RDB$FIELD_SUB_TYPE = FST.RDB$TYPE)
WHERE FT.RDB$FIELD_NAME = 'RDB$FIELD_TYPE'
AND F.RDB$FIELD_TYPE = FT.RDB$TYPE;


/* SELECT */ 
SELECT FIRST 1000 
       RF.RDB$FIELD_NAME,     FT.RDB$TYPE_NAME,     FST.RDB$TYPE_NAME, 
       F.RDB$FIELD_LENGTH,    F.RDB$FIELD_SCALE,    F.RDB$FIELD_PRECISION, 
       RF.RDB$FIELD_SOURCE,   F.RDB$FIELD_TYPE,     F.RDB$FIELD_SUB_TYPE, 
       F.RDB$DEFAULT_VALUE,   RF.RDB$RELATION_NAME, RF.RDB$FIELD_POSITION 
FROM RDB$FIELDS F, RDB$TYPES FT LEFT OUTER JOIN RDB$TYPES FST 
ON (FST.RDB$FIELD_NAME = 'RDB$FIELD_SUB_TYPE' 
  AND F.RDB$FIELD_SUB_TYPE = FST.RDB$TYPE), RDB$RELATION_FIELDS RF, RDB$RELATIONS R 
WHERE FT.RDB$FIELD_NAME  = 'RDB$FIELD_TYPE' 
AND F.RDB$FIELD_TYPE     = FT.RDB$TYPE 
AND F.RDB$SYSTEM_FLAG    = 0 
AND F.RDB$FIELD_NAME     = RF.RDB$FIELD_SOURCE 
AND RF.RDB$RELATION_NAME = R.RDB$RELATION_NAME 
/* AND (RF.RDB$FIELD_NAME LIKE '%MAIN%' OR RF.RDB$FIELD_NAME LIKE '%PARENT%') */
/* AND RF.RDB$FIELD_NAME LIKE '%PERS%' */
/* AND RF.RDB$FIELD_NAME LIKE '%ORG%' */
/* AND RF.RDB$FIELD_NAME LIKE '%DEP%' */
/* AND (RF.RDB$FIELD_NAME LIKE '%CD%' OR RF.RDB$FIELD_NAME LIKE '%CODE%') */
/* AND RF.RDB$FIELD_NAME LIKE '%ID%' */
AND RF.RDB$FIELD_NAME LIKE '%XX%' 
ORDER BY RF.RDB$FIELD_NAME, RF.RDB$RELATION_NAME, RF.RDB$FIELD_POSITION; 


SELECT DISTINCT 
       RF.RDB$FIELD_NAME,     FT.RDB$TYPE_NAME,     FST.RDB$TYPE_NAME,     
       F.RDB$FIELD_LENGTH,    F.RDB$FIELD_SCALE,    F.RDB$FIELD_PRECISION
FROM RDB$FIELDS F, RDB$TYPES FT LEFT OUTER JOIN RDB$TYPES FST
ON (FST.RDB$FIELD_NAME = 'RDB$FIELD_SUB_TYPE'
  AND F.RDB$FIELD_SUB_TYPE = FST.RDB$TYPE), RDB$RELATION_FIELDS RF, RDB$RELATIONS R
WHERE FT.RDB$FIELD_NAME  = 'RDB$FIELD_TYPE'
AND F.RDB$FIELD_TYPE     = FT.RDB$TYPE
AND F.RDB$SYSTEM_FLAG    = 0
AND F.RDB$FIELD_NAME     = RF.RDB$FIELD_SOURCE
AND RF.RDB$RELATION_NAME = R.RDB$RELATION_NAME
ORDER BY RF.RDB$FIELD_NAME desc, RF.RDB$RELATION_NAME, RF.RDB$FIELD_POSITION;

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
INSERT INTO SYS_FIELD;
SELECT DISTINCT 
       RF.RDB$FIELD_NAME,     1,                     F.RDB$FIELD_TYPE,     
       F.RDB$FIELD_LENGTH,    0,
       '',                    '',                    '',
       '',                    '',                    '',
       '1900-01-01',          'SYS'
FROM RDB$FIELDS F, RDB$TYPES FT LEFT OUTER JOIN RDB$TYPES FST
ON (FST.RDB$FIELD_NAME = 'RDB$FIELD_SUB_TYPE'
  AND F.RDB$FIELD_SUB_TYPE = FST.RDB$TYPE), RDB$RELATION_FIELDS RF, RDB$RELATIONS R
WHERE FT.RDB$FIELD_NAME  = 'RDB$FIELD_TYPE'
AND F.RDB$FIELD_TYPE     = FT.RDB$TYPE
AND F.RDB$SYSTEM_FLAG    = 0
AND F.RDB$FIELD_NAME     = RF.RDB$FIELD_SOURCE
AND RF.RDB$RELATION_NAME = R.RDB$RELATION_NAME
AND RF.RDB$FIELD_NAME NOT IN (SELECT FIELDNAME FROM SYS_FIELD)
ORDER BY RF.RDB$FIELD_NAME;

---------------------------------------------------------------------------------------

INSERT INTO SYS_RECORD;
SELECT DISTINCT 
       RF.RDB$RELATION_NAME,  1,                     'T',     
       '',                    '',                    '',
       '',
       '',                    '',                    '',
       '1900-01-01',          'SYS'
FROM RDB$FIELDS F, RDB$TYPES FT LEFT OUTER JOIN RDB$TYPES FST
ON (FST.RDB$FIELD_NAME = 'RDB$FIELD_SUB_TYPE'
  AND F.RDB$FIELD_SUB_TYPE = FST.RDB$TYPE), RDB$RELATION_FIELDS RF, RDB$RELATIONS R
WHERE FT.RDB$FIELD_NAME  = 'RDB$FIELD_TYPE'
AND F.RDB$FIELD_TYPE     = FT.RDB$TYPE
AND F.RDB$SYSTEM_FLAG    = 0
AND F.RDB$FIELD_NAME     = RF.RDB$FIELD_SOURCE
AND RF.RDB$RELATION_NAME = R.RDB$RELATION_NAME
AND RF.RDB$RELATION_NAME NOT IN (SELECT RECORDNAME FROM SYS_RECORD)
ORDER BY RF.RDB$RELATION_NAME;

---------------------------------------------------------------------------------------

INSERT INTO SYS_RECORDFIELD;
SELECT DISTINCT 
       RF.RDB$RELATION_NAME,  RF.RDB$FIELD_NAME,     RF.RDB$FIELD_POSITION+1,
       '1',                   
       '',                    '',                    '',
       '',                    '',                    '',
       '',                    '',                    '',
       '1900-01-01',          'SYS'
FROM RDB$FIELDS F, RDB$TYPES FT LEFT OUTER JOIN RDB$TYPES FST
ON (FST.RDB$FIELD_NAME = 'RDB$FIELD_SUB_TYPE'
  AND F.RDB$FIELD_SUB_TYPE = FST.RDB$TYPE), RDB$RELATION_FIELDS RF, RDB$RELATIONS R
WHERE FT.RDB$FIELD_NAME  = 'RDB$FIELD_TYPE'
AND F.RDB$FIELD_TYPE     = FT.RDB$TYPE
AND F.RDB$SYSTEM_FLAG    = 0
AND F.RDB$FIELD_NAME     = RF.RDB$FIELD_SOURCE
AND RF.RDB$RELATION_NAME = R.RDB$RELATION_NAME
AND RF.RDB$RELATION_NAME NOT IN (SELECT A.RECORDNAME FROM SYS_RECORDFIELD A WHERE RF.RDB$FIELD_NAME = A.FIELDNAME)
ORDER BY RF.RDB$RELATION_NAME, RF.RDB$FIELD_POSITION, RF.RDB$FIELD_NAME;
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

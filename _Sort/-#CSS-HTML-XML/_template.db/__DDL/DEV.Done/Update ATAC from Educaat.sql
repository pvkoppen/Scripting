USE AC_WEB
/*
select so.name+'   '+ sc.name from sysobjects so join syscolumns sc on (so.id = sc.id)
where so.name like 'EXT_PERS%'
and so.type = 'U'
order by so.name, sc.colid
*/
GO
-- ---------------------------------------------------------------------
-- --- VOORBEREIDING
-- ---------------------------------------------------------------------
/*
UPDATE EXT_PERS_EDU SET AANHEF = 'M' WHERE AANHEF = 'DE HEER'
UPDATE EXT_PERS_EDU SET AANHEF = 'F' WHERE AANHEF = 'MEVROUW'
SELECT TOP 10 * FROM EXT_PERS_EDU WHERE AANHEF NOT IN ('M','F')
DELETE FROM EXT_PERS_EDU WHERE STAMNR IS NULL
--
UPDATE EXT_PERS_EDU  SET STAMNR      = '000'+STAMNR      WHERE LEN(STAMNR)      <= 12-3 AND LEN(STAMNR)     > 0
UPDATE EXT_PERS_EDU  SET STAMNR      =  '00'+STAMNR      WHERE LEN(STAMNR)      <= 12-2 AND LEN(STAMNR)     > 0
UPDATE EXT_PERS_EDU  SET STAMNR      =   '0'+STAMNR      WHERE LEN(STAMNR)      <= 12-1 AND LEN(STAMNR)     > 0
UPDATE EXT_PERSONEEL SET EXT_PERSID  = '000'+EXT_PERSID  WHERE LEN(EXT_PERSID)  <= 12-3 AND LEN(EXT_PERSID) > 0
UPDATE EXT_PERSONEEL SET EXT_PERSID  =  '00'+EXT_PERSID  WHERE LEN(EXT_PERSID)  <= 12-2 AND LEN(EXT_PERSID) > 0
UPDATE EXT_PERSONEEL SET EXT_PERSID  =   '0'+EXT_PERSID  WHERE LEN(EXT_PERSID)  <= 12-1 AND LEN(EXT_PERSID) > 0
UPDATE PERSONEEL     SET EXT_PERS_ID = '000'+EXT_PERS_ID WHERE LEN(EXT_PERS_ID) <= 12-3 AND LEN(EXT_PERS_ID)> 0
UPDATE PERSONEEL     SET EXT_PERS_ID =  '00'+EXT_PERS_ID WHERE LEN(EXT_PERS_ID) <= 12-2 AND LEN(EXT_PERS_ID)> 0
UPDATE PERSONEEL     SET EXT_PERS_ID =   '0'+EXT_PERS_ID WHERE LEN(EXT_PERS_ID) <= 12-1 AND LEN(EXT_PERS_ID)> 0
UPDATE PERSONEEL SET EXT_PERS_ID = ' ' WHERE EXT_PERS_ID IS NULL OR EXT_PERS_ID = '000000000000'
--
*/
--DELETE FROM EXT_PERSONEEL 
-- ---------------------------------------------------------------------
-- --- SELECTIE
-- ---------------------------------------------------------------------
SELECT TOP 10 * FROM EXT_PERSONEEL 
SELECT TOP 10 * FROM EXT_PERS_EDU  
SELECT TOP 10 * FROM PERSONEEL     
-- ---------------------------------------------------------------------
-- --- HISTORY IMPORTEREN
-- ---------------------------------------------------------------------
/*
INSERT INTO EXT_PERSONEEL (EXT_PERSID, ACTIEDATUM, STATUS)
	SELECT DISTINCT EXT_PERS_ID, '2002-04-06', 'A' 
	FROM PERSONEEL 
	WHERE EXT_PERS_ID IS NOT NULL 
	AND EXT_PERS_ID <> ''
	AND EXT_PERS_ID NOT IN (SELECT EXT_PERSID FROM EXT_PERSONEEL)
-- ---------------------------------------------------------------------
UPDATE EXT_PERSONEEL
SET VOORLETTERS   = B.VOORLETTERS,
	VOORNAAM      = B.VOORNAAM,
	TUSSENVOEG    = B.TUSSENV,
	ACHTERNAAM    = B.ACHTERNAAM,
	VOLLEDIGENAAM = B.ACHTERNAAM,
	FUNCTIE       = C.NAAM,
	SORTKENMERK   = ' ',
	SEXE          = B.SEXEID,
	PRIVETELNR    = ' ',
	BIRTHDATE     = B.GEBDATUM
--SELECT * 
FROM EXT_PERSONEEL A JOIN PERSONEEL B 
	ON (A.EXT_PERSID = B.EXT_PERS_ID) LEFT OUTER JOIN FUNCTIES C
	ON (B.FUNCTIE_ID = C.FUNCTIE_ID)
*/
-- ---------------------------------------------------------------------
-- --- NIEUWE RECORD TOEVOEGEN
-- ---------------------------------------------------------------------
/*
INSERT INTO EXT_PERSONEEL (EXT_PERSID, ACTIEDATUM, STATUS)
	SELECT DISTINCT stamnr, SUBSTRING(CONVERT(CHAR,GETDATE()),1,11), 'A' 
	FROM EXT_PERS_EDU 
	WHERE stamnr NOT IN (SELECT EXT_PERSID FROM EXT_PERSONEEL)
*/
-- ---------------------------------------------------------------------
-- --- VERBREEK RELATIES.
-- ---------------------------------------------------------------------
/*
INSERT INTO EXT_PERSONEEL (EXT_PERSID, ACTIEDATUM, STATUS)
	SELECT DISTINCT EXT_PERSID, SUBSTRING(CONVERT(CHAR,GETDATE()),1,11), 'I' 
	FROM EXT_PERSONEEL
	WHERE EXT_PERSID NOT IN (SELECT stamnr FROM EXT_PERS_EDU)
*/
-- ---------------------------------------------------------------------
-- --- UPDATE PERSONEELS GEGEVENS.
-- ---------------------------------------------------------------------
/*
UPDATE EXT_PERS_EDU SET AANHEF = '' WHERE AANHEF IS NULL
UPDATE EXT_PERS_EDU SET VOORNAAM = '' WHERE VOORNAAM IS NULL
UPDATE EXT_PERS_EDU SET VOORLETTERS = '' WHERE VOORLETTERS IS NULL
UPDATE EXT_PERS_EDU SET VOORVOEGSEL = '' WHERE VOORVOEGSEL IS NULL
UPDATE EXT_PERS_EDU SET NAAM = '' WHERE NAAM IS NULL
UPDATE EXT_PERS_EDU SET VOLLENAAM = '' WHERE VOLLENAAM IS NULL
UPDATE EXT_PERS_EDU SET FUNCTIE = '' WHERE FUNCTIE IS NULL
UPDATE EXT_PERS_EDU SET SORTKENMERK = '' WHERE SORTKENMERK IS NULL
UPDATE EXT_PERS_EDU SET TELNR = '' WHERE TELNR IS NULL
-- ---------------------------------------------------------------------
UPDATE EXT_PERS_EDU SET AANHEF      = UPPER(AANHEF)
UPDATE EXT_PERS_EDU SET VOORNAAM    = UPPER(SUBSTRING(VOORNAAM,1,1))+LOWER(SUBSTRING(VOORNAAM,2, LEN(VOORNAAM)-1)) WHERE LEN(VOORNAAM) >1
UPDATE EXT_PERS_EDU SET VOORLETTERS = UPPER(VOORLETTERS)
UPDATE EXT_PERS_EDU SET VOORVOEGSEL = LOWER(VOORVOEGSEL)
UPDATE EXT_PERS_EDU SET NAAM        = UPPER(SUBSTRING(NAAM,1,1))+LOWER(SUBSTRING(NAAM,2, LEN(NAAM)-1)) WHERE LEN(NAAM) >1
UPDATE EXT_PERS_EDU SET VOLLENAAM   = UPPER(SUBSTRING(VOLLENAAM,1,1))+LOWER(SUBSTRING(VOLLENAAM,2, LEN(VOLLENAAM)-1)) WHERE LEN(VOLLENAAM) >1
UPDATE EXT_PERS_EDU SET FUNCTIE     = '' WHERE FUNCTIE IS NULL
UPDATE EXT_PERS_EDU SET SORTKENMERK = '' WHERE SORTKENMERK IS NULL
UPDATE EXT_PERS_EDU SET TELNR       = '' WHERE TELNR IS NULL
*/
-- ---------------------------------------------------------------------
SELECT * 
/*
UPDATE EXT_PERSONEEL
SET VOORLETTERS   = B.VOORLETTERS,
	VOORNAAM      = B.VOORNAAM,
	TUSSENVOEG    = B.VOORVOEGSEL,
	ACHTERNAAM    = B.NAAM,
    VOLLEDIGENAAM = B.VOLLENAAM,
	SORTKENMERK   = B.SORTKENMERK,
	PRIVETELNR    = B.TELNR,
	SEXE          = B.AANHEF,
	BIRTHDATE     = B.GEBDATUM
-- */
FROM EXT_PERSONEEL A JOIN EXT_PERS_EDU B
  ON (A.EXT_PERSID = B.STAMNR)
WHERE ((A.VOORLETTERS <> B.VOORLETTERS AND B.VOORLETTERS <> '' AND B.VOORLETTERS IS NOT NULL) OR (A.VOORLETTERS   IS NULL AND B.VOORLETTERS IS NOT NULL))
OR ((A.VOORNAAM       <> B.VOORNAAM    AND B.VOORNAAM    <> '' AND B.VOORNAAM    IS NOT NULL) OR (A.VOORNAAM      IS NULL AND B.VOORNAAM    IS NOT NULL))
OR ((A.TUSSENVOEG     <> B.VOORVOEGSEL AND B.VOORVOEGSEL <> '' AND B.VOORVOEGSEL IS NOT NULL) OR (A.TUSSENVOEG    IS NULL AND B.VOORVOEGSEL IS NOT NULL))
OR ((A.ACHTERNAAM     <> B.NAAM        AND B.NAAM        <> '' AND B.NAAM        IS NOT NULL) OR (A.ACHTERNAAM    IS NULL AND B.NAAM        IS NOT NULL))
OR ((A.VOLLEDIGENAAM  <> B.VOLLENAAM   AND B.VOLLENAAM   <> '' AND B.VOLLENAAM   IS NOT NULL) OR (A.VOLLEDIGENAAM IS NULL AND B.VOLLENAAM   IS NOT NULL))
OR ((A.SORTKENMERK    <> B.SORTKENMERK AND B.SORTKENMERK <> '' AND B.SORTKENMERK IS NOT NULL) OR (A.SORTKENMERK   IS NULL AND B.SORTKENMERK IS NOT NULL))
OR ((A.PRIVETELNR     <> B.TELNR       AND B.TELNR       <> '' AND B.TELNR       IS NOT NULL) OR (A.PRIVETELNR    IS NULL AND B.TELNR       IS NOT NULL))
OR ((A.SEXE           <> B.AANHEF      AND B.AANHEF      <> '' AND B.AANHEF      IS NOT NULL) OR (A.SEXE          IS NULL AND B.AANHEF      IS NOT NULL))
OR ((A.BIRTHDATE      <> B.GEBDATUM                            AND B.GEBDATUM    IS NOT NULL) OR (A.BIRTHDATE     IS NULL AND B.GEBDATUM    IS NOT NULL))
-- ---------------------------------------------------------------------
-- --- UPDATE PERSONEELS GEGEVENS.
-- ---------------------------------------------------------------------
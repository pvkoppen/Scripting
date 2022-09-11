/*
-- ------------------------------------------------------------------------------
-- Dit script is een samenvoegsel van een stukje eigen sql programmeer werk 
-- en twee scripts die door Peoplesoft zijn meegeleverd met Peopletools. 
-- Het eerste Peoplesoft script verwijderd alle geregistreerde Peoplesoft 
-- gebruikers van de database. Het tweede script voegt deze zelfde mensen 
-- weer aan de database toe, nu alleen met het correcte server uid (Unique 
-- ID). Dit doet alleen niets aan de verschillen die er tussen de 
-- AccessProfiles bestaan. Het stukje eigen programmeer werk doet daar wat 
-- aan alleen zal het wel nog even met de hand aangepast moeten worden.
-- ------------------------------------------------------------------------------
-- 
-- KPP Alfa-college 2002-10-23 Commentaar toegevoegd
-- ------------------------------------------------------------------------------
*/
/*
-- ------------------------------------------------------------------------------
-- --- Begin: Eigen product
-- ------------------------------------------------------------------------------
SELECT 'REPORT ALL POSSIBLE COMBINATIONS'
SELECT A.loginname, A.name, B.name, A.suid, B.suid FROM [master].[dbo].syslogins A, [dbo].sysusers B ORDER BY 1,2,3
--GO
SELECT 'REPORT TOP 10 NAME-LOGINNAME COMBIS(+ SA-DBO) WITH ERRORS'
SELECT TOP 10 A.loginname, A.name, B.name, A.suid, B.suid FROM [master].[dbo].syslogins A JOIN [dbo].sysusers B ON (A.loginname = B.name OR (A.loginname = 'sa' AND B.name = 'dbo')) WHERE B.suid IS NULL ORDER BY 1,2,3
--GO
BEGIN TRAN
UPDATE [dbo].sysusers SET sid = A.sid
FROM [master].[dbo].syslogins A JOIN [dbo].sysusers B ON (A.loginname = B.name OR (A.loginname = 'sa' AND B.name = 'dbo'))
WHERE B.suid IS NULL
ROLLBACK
--COMMIT
--GO
SELECT 'REPORT ALL NAME-LOGINNAME COMBIS(+ SA-DBO) WITH ERRORS'
SELECT A.loginname, A.name, B.name, A.suid, B.suid FROM [master].[dbo].syslogins A JOIN [dbo].sysusers B ON (A.loginname = B.name OR (A.loginname = 'sa' AND B.name = 'dbo')) WHERE B.suid IS NULL ORDER BY 1,2,3
--GO
SELECT 'REPORT ALL NAME-LOGINNAME COMBIS(+ SA-DBO)AND THE UNKNOWNS WITH ERRORS'
SELECT A.loginname, A.name, B.name, A.suid, B.suid FROM [master].[dbo].syslogins A FULL OUTER JOIN [dbo].sysusers B ON (A.loginname = B.name OR (A.loginname = 'sa' AND B.name = 'dbo')) WHERE ((A.name IS NULL AND B.altuid <> 1) OR B.name IS NULL) ORDER BY 1,2,3

*/
-- ------------------------------------------------------------------------------
-- --- Deel 2
-- ------------------------------------------------------------------------------
/*
USE SA76AAR
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76ACC
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76AUD
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76BPV
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76ONT
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76RES
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76SY2
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76SYS
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN
--GO
USE SA76ACC
SELECT DB_NAME(DB_ID())
SELECT * FROM PSACCESSPRFL
SELECT * FROM PSOPRDEFN WHERE OPRTYPE = 0
*/
/*
begin tran
UPDATE PSACCESSPRFL
SET ACCESSPSWD = '5F852CF78A06A583',
	VERSION = 1431,
	ENCRYPTED = 1
UPDATE PSOPRDEFN
SET ACCESSPSWD = 'sa',
	OPERPSWD = '0000000000000000',
	ENCRYPTED = 0
WHERE OPRTYPE = 0
commit
sa       1           5F852CF78A06A583 1 SRV_IMPL (2002-10-23)
sa       644         5F852CF78A06A583 1 SRV_IMPL (2002-10-23)
sa       1430        3AC96F4139C913B2 1 ALFAM01 (2002-10-23)
-- ------------------------------------------------------------------------------
-- --- Einde: Eigen product
-- ------------------------------------------------------------------------------
*/
-- ******************************************************************
--           Confidentiality Information:
--
--   This module is the confidential and proprietary information of
--    PeopleSoft, Inc.; it is not to be copied, reproduced, or
--    transmitted in any form, by any means, in whole or in part,
--    nor is it to be used for any purpose other than that for which
--    it is expressly provided without the written permission of
--    PeopleSoft, Inc.
--
--    Copyright (c) 1988-2000 PeopleSoft, Inc. All Rights Reserved
-- ******************************************************************
--    SourceSafe Information:
--
--    Header:  /PT7/SCRIPTS/MSS/DROPUSER.SQL  2/13/98
-- ******************************************************************
--    DROPUSER.SQL - Drop Database Users Script
-- ******************************************************************
--    Instructions:
--
--    Use caution when running this script.  This will DROP database
--    users.
--
--    Run script using ISQL/w while in the PeopleSoft database.
--
--    Purpose:
--
--     For each OPRID in PSOPRDEFN:
--     Drop database user.
--
--     This is useful when restoring a database from one server to
--     another and the database server logins do not match the
--     database users.
-- ******************************************************************

SET NOCOUNT ON
go

PRINT ' '
PRINT 'Executing dropuser.sql...'
PRINT ' '
go

-- Check to make sure that the PeopleSoft database is in USE
IF NOT EXISTS (SELECT 'X' FROM sysobjects WHERE name = 'PSOPRDEFN')
BEGIN
    PRINT 'PSOPRDEFN table not found!'
    PRINT 'Rerun this SQL script in the PeopleSoft database!'
END
go

-- Get valid OPRID's from PSOPRDEFN
DECLARE @OPRID     varchar(30)
DECLARE OPRID_CURSOR CURSOR FOR
    SELECT OPRID FROM PSOPRDEFN
    WHERE OPRTYPE = 0

OPEN OPRID_CURSOR

FETCH NEXT FROM OPRID_CURSOR INTO @OPRID

WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
    BEGIN
        SELECT @OPRID = RTRIM(@OPRID)
        PRINT ' '
        EXEC ('PRINT ''Processing *** '  + @OPRID + ' ***''')

-- Drop user

        IF EXISTS (SELECT 'X'
                   FROM sysusers
                   WHERE name = @OPRID)
            EXEC ('sp_dropuser ' + @OPRID )
        ELSE
            EXEC ('PRINT ''User ' + @OPRID + ' does not exist.''')

    END
    FETCH NEXT FROM OPRID_CURSOR INTO @OPRID
END

DEALLOCATE OPRID_CURSOR

PRINT ' '
PRINT 'Done!'
PRINT ' '

go

-- ******************************************************************
--           Confidentiality Information:
--
--   This module is the confidential and proprietary information of
--    PeopleSoft, Inc.; it is not to be copied, reproduced, or
--    transmitted in any form, by any means, in whole or in part,
--    nor is it to be used for any purpose other than that for which
--    it is expressly provided without the written permission of
--    PeopleSoft, Inc.
--
--    Copyright (c) 1988-2000 PeopleSoft, Inc. All Rights Reserved
-- ******************************************************************
--    SourceSafe Information:
--
--    Header:  /PT7/SCRIPTS/MSS/ADDOPERS.SQL  6/30/97
-- ******************************************************************
--    ADDOPERS.SQL - Add Operators Script
-- ******************************************************************
--    Instructions:
--
--    Run script using ISQL/w while in the PeopleSoft database.
--
--    Purpose:
--
--     For each OPRID in PSOPRDEFN:
--     Add login with password = OPRID
--     Add database user
--     GRANT SELECT ON PSLOCK and PSOPRDEFN
-- ******************************************************************


SET NOCOUNT ON
go

PRINT ' '
PRINT 'Executing addopers.sql...'
PRINT ' '
go

IF NOT EXISTS (SELECT 'X' FROM sysobjects WHERE name = 'PSOPRDEFN')
BEGIN
    PRINT 'PSOPRDEFN table not found!'
    PRINT 'Rerun this SQL script in the PeopleSoft database!'
END
go

DECLARE @OPRID     varchar(30)
DECLARE OPRID_CURSOR CURSOR FOR
    SELECT OPRID FROM PSOPRDEFN
    WHERE OPRTYPE = 0

OPEN OPRID_CURSOR

FETCH NEXT FROM OPRID_CURSOR INTO @OPRID

WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
    BEGIN
        SELECT @OPRID = RTRIM(@OPRID)
        PRINT ' '
        EXEC ('PRINT ''Processing *** '  + @OPRID + ' ***''')

--
-- Add login
--
        IF EXISTS (SELECT 'X'
                   FROM master..syslogins
                   WHERE name = @OPRID)
            EXEC ('PRINT ''Login ' + @OPRID + ' already exists.''')
        ELSE
            EXEC ('sp_addlogin ' + @OPRID + ',' + @OPRID )
--
-- Add user
--
        IF EXISTS (SELECT 'X'
                   FROM sysusers
                   WHERE name = @OPRID)
            EXEC ('PRINT ''User ' + @OPRID + ' already exists.''')
        ELSE
            EXEC ('sp_adduser ' + @OPRID )

--
-- GRANT SELECT
--
        EXEC ('GRANT SELECT ON PSLOCK TO ' + @OPRID )
        EXEC ('GRANT SELECT ON PSOPRDEFN TO ' + @OPRID )
        EXEC ('PRINT ''Select granted.''')

    END
    FETCH NEXT FROM OPRID_CURSOR INTO @OPRID
END

DEALLOCATE OPRID_CURSOR

PRINT ' '
PRINT 'Done!'
PRINT ' '

go


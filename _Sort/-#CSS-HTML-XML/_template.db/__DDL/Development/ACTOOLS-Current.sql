
-------------------------------------------------------------------------------
-- Template DB: SYSTEM Tables
-------------------------------------------------------------------------------

/* Table: SYS_ACCESS, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_ACCESSDEFN] (
	[ACCESSID] [nvarchar] (8) NOT NULL,
	[ACCESSENCCD] [nvarchar] (6),
	[ACCESSSECPW] [nvarchar] (20)  
) ON [PRIMARY]
GO

/* Table: SYS_ACTION, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_ACTIONDEFN] (
	[ACTIONID] [nvarchar] (12) NOT NULL,
	[SCHEDID] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_ACTIONITEM, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_ACTIONITEMS] (
	[ACTIONID] [nvarchar] (12) NOT NULL,
	[SEQUENCENR] [nvarchar] (6) NOT NULL,
	[CONID] [nvarchar] (12),
	[SQLACTIONID] [nvarchar] (12)  
) ON [PRIMARY]
GO

/* Table: SYS_CONFIGBASE, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_CONFIGBASE] (
	[LANGUAGE_BASE] [nvarchar] (6),
	[CURRENCY_BASE] [nvarchar] (6),
	[APPNAME] [nvarchar] (?),
	[APPVERSION] [nvarchar] (?),
	[PERSID_LAST] [nvarchar] (12) COLLATE Latin1_General_BIN NULL ,
	[ORGID_LAST] [nvarchar] (12) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

/* Table: SYS_CONNECTION, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_CONDEFN] (
	[CONID] [nvarchar] (12) NOT NULL,
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [ntext],
	[CONTYPE] [nvarchar] (6),
	[CONSOURCE] [nvarchar] (64),
	[CONLOGIN] [nvarchar] (12),
	[CONPW] [nvarchar] (12)  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_CONNECTIONSQL, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_CONSQLDEFN] (
	[CONID] [nvarchar] (12) NOT NULL,
	[SQLACTIONID] [nvarchar] (12) NOT NULL,
	[SQLSTTMNT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_FIELD, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_FIELDDEFN] (
	[FIELDNAME] [nvarchar] (20) NOT NULL,
	[VERSION] [int] NULL,
	[FIELDTYPE] [nvarchar] (6),
	[FIELDSIZE] [nvarchar] (3),
	[DECIMALS] [nvarchar] (2),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRTEXT] [ntext],
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_FIELDLANG, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_FIELDDEFN_LNG] (
	[FIELDNAME] [nvarchar] (20) NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRTEXT] [ntext],
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_FIELDVALUE, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_FIELDVALUE] (
	[FIELDNAME] [nvarchar] (20) NOT NULL,
	[FIELDVALUE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY]
GO

/* Table: SYS_FIELDVALUELANG, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_FIELDVALUE_LNG] (
	[FIELDNAME] [nvarchar] (20) NOT NULL,
	[FIELDVALUE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: SYS_GENERATEDID, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_GENERATEDID_TBL] (
	[IDNAME] [nvarchar] (12),
	[IDMAXSIZE] [nvarchar] (12)  
	[IDDEFAULTSIZE] [nvarchar] (12),
	[IDLASTVALUE] [nvarchar] (12)  
) ON [PRIMARY]
GO

/* Table: SYS_LANGUAGE, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_LANGUAGE_TBL] (
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_OPERATOR, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_OPRDEFN] (
	[OPRID] [nvarchar] (8) NOT NULL,
	[OPRTYPE] [nvarchar] (6),
	[PERSID] [nvarchar] (12),
	[NAME] [nvarchar] (60),
	[ENCRYPTCD] [nvarchar] (6),
	[SECURITY_PW] [nvarchar] (20),
	[ACCESSID] [nvarchar] (8),
	[ACCESSENCCD] [nvarchar] (6),
	[ACCESSSECPW] [nvarchar] (20),
	[OPRGRPPREF] [nvarchar] (8),
	[LANGUAGECD] [nvarchar] (6),
	[DESCRTEXT] [ntext],
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_OPRPAGEACCESS, Owner: SYSDBA */
CREATE TABLE SYS_OPRPAGEACCESS (OPRID VARCHAR(20) NOT NULL,
        PAGENAME VARCHAR(20) NOT NULL,
        ACCESSTYPE VARCHAR(6) NOT NULL,
        LASTUPDATEDTTM TIMESTAMP,
        LASTUPDATEOPRID VARCHAR(20),
PRIMARY KEY (OPRID, PAGENAME));

/* Table: SYS_OPRRECORDACCESS, Owner: SYSDBA */
CREATE TABLE SYS_OPRRECORDACCESS (OPRID VARCHAR(20) NOT NULL,
        RECORDNAME VARCHAR(20) NOT NULL,
        ACCESSTYPE VARCHAR(6) NOT NULL,
        LASTUPDATEDTTM TIMESTAMP,
        LASTUPDATEOPRID VARCHAR(20),
PRIMARY KEY (OPRID, RECORDNAME));

/* Table: SYS_RECORD, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_RECDEFN] (
	[RECNAME] [nvarchar] (17) NOT NULL,
	[VERSION] [int] NULL,
	[RECTYPE] [nvarchar] (6),
	[DESCR] [nvarchar] (64),
	[DESCRTEXT] [ntext],
	[PARENTREC] [nvarchar] (17),
	[SEARCHREC] [nvarchar] (17),
	[SQLTABLE] [nvarchar] (20),
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_RECORDFIELD, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_RECFIELD] (
	[RECNAME] [nvarchar] (17) NOT NULL,
	[FIELDNAME] [nvarchar] (20) NOT NULL,
	[SEQNUMBER] [int] NULL,
	[KEYFIELD] [nvarchar] (1),
	[SEARCHFIELD] [nvarchar] (1),
	[ALTSEARCHFIELD] [nvarchar] (1),
	[LISTBOXITEM] [nvarchar] (1),
	[REQUIRED] [nvarchar] (1),
	[DREFTYPE] [nvarchar] (6),
	[DREFREC] [nvarchar] (17),
	[DREFRECFIELD] [nvarchar] (20),
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY]
GO

/* Table: SYS_RECORDLANG, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_RECDEFN_LNG] (
	[RECNAME] [nvarchar] (17) NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCR] [nvarchar] (64),
	[DESCRTEXT] [ntext],
	[LASTUPDDTTM] [smalldatetime] NULL,
	[LASTUPDOPRID] [nvarchar] (8)  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: SYS_SCHEDULE, Owner: SYSDBA */
CREATE TABLE [dbo].[SYS_SCHEDULE] (
	[SCHEDID] [nvarchar] (12) NOT NULL,
	[SCHEDTYPE] [nvarchar] (6),
	[SCHEDDATE] [smalldatetime] NULL,
	[SCHEDTIME] [smalldatetime] NULL,
	[SCHEDDAY] [nvarchar] (6),
	[SCHEDWEEK] [nvarchar] (6),
	[SCHEDMONTH] [nvarchar] (6),
	[SCHEDYEAR] [nvarchar] (6)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Template DB: Data Tables
-------------------------------------------------------------------------------

/* Table: DB_BUILDING, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_BUILDING_TBL] (
	[BLDGID] [nvarchar] (12) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
	[Locatie Nummer] [float] NULL,
	[COUNTRY] [nvarchar] (6),
	[STREET] [nvarchar] (30),
	[NR1] [nvarchar] (6),
	[NR2] [nvarchar] (6),
	[POSTAL] [nvarchar] (8),
	[CITY] [nvarchar] (6),
	[STATE] [nvarchar] (6)  
  FIRSTCONTACT CHAR(12))
	[e-mail] [nvarchar] (255) NULL,
	[soort telefoonnr] [nvarchar] (255) NULL,
	[telefoonnr] [nvarchar] (255) NULL,
	[soort telefoonnr2] [nvarchar] (255) NULL,
	[telefoonnr2] [nvarchar] (255) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_CITY, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_CITY_TBL] (
	[COUNTRY] [nvarchar] (6) NOT NULL,
	[CITY] [nvarchar] (6) NOT NULL,
	[STATE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_COUNTRY, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_COUNTRY_TBL] (
	[COUNTRY] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_COUNTRYLANG, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_COUNTRY_LNG] (
	[COUNTRY] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_CURRENCY, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_CURRENCY_TBL] (
	[CURRENCY] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[EXCHANGERATE] [varchar] (?),
	[EXCHANGEBUNDLE] [nvarchar] (?)COLLATE Latin1_General_BIN NULL 
	[EXCHANGECURRENCY] [nvarchar] (?),
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_DEPARTMENT_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_DEPARTMENT_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[DEPTID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_EMPLOYMENT_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_EMPLOYMENT_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[PERSID] [nvarchar] (12) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DEPTID] [nvarchar] (6),
	[SUBDEPTID] [nvarchar] (6),
	[SECTIONID] [nvarchar] (6),
	[SUBSECTIONID] [nvarchar] (6),
	[LOCID] [nvarchar] (6),
	[BLDGID] [nvarchar] (12),
	[ROOMID] [nvarchar] (6),
	[FUNCTIONID] [nvarchar] (6)  
) ON [PRIMARY]
GO

/* Table: DB_ENROLLMENT_DT, Owner: SYSDBA */

/* Table: DB_ETHNICITY, Owner: SYSDBA */

/* Table: DB_ETHNICITYLANG, Owner: SYSDBA */

/* Table: DB_FUNCTIONGROUP, Owner: SYSDBA */

/* Table: DB_FUNCTION_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_FUNCTION_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[FUNCTIONID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
	[LASTUPDOPRID] [nvarchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_LOCATION_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_LOCATION_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[LOCID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
  FIRSTCONTACT CHAR(12)
	[COUNTRY] [nvarchar] (6),
	[STREET] [nvarchar] (30),
	[NR1] [nvarchar] (6),
	[NR2] [nvarchar] (6),
	[POSTAL] [nvarchar] (8),
	[CITY] [nvarchar] (6),
	[STATE] [nvarchar] (6)  
	[LASTUPDOPRID] [nvarchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_LOC_BLDG_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_LOC_BLDG_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[LOCID] [nvarchar] (6) NOT NULL,
	[BLDGID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_NAMEINFIX_LNG, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NAMEINFIX_LNG] (
	[NAMEINFIX] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NAMEINFIX_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NAMEINFIX_TBL] (
	[NAMEINFIX] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NAMEPOSTFIX_LNG, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NAMEPOSTFIX_LNG] (
	[NAMESUFFIX] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NAMEPOSTFIX_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NAMEPOSTFIX_TBL] (
	[NAMESUFFIX] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NAMEPREFIX_LNG, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NAMEPREFIX_LNG] (
	[NAMEPREFIX] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NAMEPREFIX_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NAMEPREFIX_TBL] (
	[NAMEPREFIX] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NATIONALITY, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NATIONALITY_TBL] (
	[NATIONALITY] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_NATIONALITYLANG, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_NATIONALITY_LNG] (
	[NATIONALITY] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[LANGUAGECD] [nvarchar] (6) NOT NULL,
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64)  
) ON [PRIMARY]
GO

/* Table: DB_ORGANIZATION_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_ORGANIZATION_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext],
	[HEADOFFICE] [nvarchar] (6)  
  FIRSTLOCATION CHAR(12),
  FIRSTCONTACT CHAR(12))
	[eigendomsinformatie] [nvarchar] (255) NULL,
	[FICE_CD] [char] (6) NOT NULL,
	[ATP_CD] [char] (6) NOT NULL,
	[ADDRESS1] [char] (35) NOT NULL,
	[ADDRESS2] [char] (35) NOT NULL,
	[ADDRESS3] [char] (35) NOT NULL,
	[ADDRESS4] [char] (35) NOT NULL,
	[NUM1] [char] (6) NOT NULL,
	[NUM2] [char] (4) NOT NULL,
	[HOUSE_TYPE] [char] (2) NOT NULL,
	[GEO_CODE] [char] (11) NOT NULL,
	[CITY] [char] (30) NOT NULL,
	[IN_CITY_LIMIT] [char] (1) NOT NULL,
	[COUNTY] [char] (30) NOT NULL,
	[STATE] [char] (6) NOT NULL,
	[POSTAL] [char] (12) NOT NULL,
	[COUNTRY] [char] (3) NOT NULL,
	[DESCR] [char] (30) NOT NULL,
	[DESCR50] [char] (50) NOT NULL,
	[DESCRSHORT] [char] (10) NOT NULL,
	[ORG_CONTACT] [smallint] NOT NULL,
	[ORG_LOCATION] [smallint] NOT NULL,
	[ORG_DEPARTMENT] [smallint] NOT NULL,
	[OFFERS_COURSES] [char] (1) NOT NULL,
	[PROPRIETORSHIP] [char] (4) NOT NULL,
	[ACT_CD] [char] (6) NOT NULL,
	[IPEDS_CD] [char] (6) NOT NULL,
	[SCHOOL_DISTRICT] [char] (50) NOT NULL,
	[ACCREDITED] [char] (1) NOT NULL,
	[TRANSCRIPT_XLATE] [char] (1) NOT NULL,
	[UNT_TYPE] [char] (3) NOT NULL,
	[EXT_TERM_TYPE] [char] (4) NOT NULL,
	[EXT_CAREER] [char] (4) NOT NULL,
	[SHARED_CATALOG] [char] (1) NOT NULL,
	[CATALOG_ORG] [char] (11) NOT NULL,
	[CHG_OTHER] [char] (1) NOT NULL,
	[SETID] [char] (5) NOT NULL,
	[VENDOR_ID] [char] (10) NOT NULL,
	[TAXPAYER_ID_NO] [char] (9) NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_ORG_TYPE, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_ORG_TYPE] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[ORGTYPE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6)  
	[EXT_ORG_TYPE] [char] (4) NOT NULL,
	[SCHOOL_CODE] [char] (10) NOT NULL,
	[SCHOOL_TYPE] [char] (3) NOT NULL,
) ON [PRIMARY]
GO

/* Table: DB_PERSADDRESS_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_PERSADDR_EFFDT] (
	[PERSID] [nvarchar] (12) NOT NULL,
	[ADDRTYPE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[COUNTRY] [nvarchar] (6),
	[STREET] [nvarchar] (30),
	[NR1] [nvarchar] (6),
	[NR2] [nvarchar] (6),
	[POSTAL] [nvarchar] (8),
	[CITY] [nvarchar] (30),
	[STATE] [nvarchar] (6)  
) ON [PRIMARY]
GO

/* Table: DB_PERSEMAIL_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_PERSEMAIL_EFFDT] (
	[PERSID] [nvarchar] (12) NOT NULL,
	[EMAILTYPE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[EMAIL] [nvarchar] (50)  
) ON [PRIMARY]
GO

/* Table: DB_PERSEXTERNALID_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_EXTERNALPERSID] (
	[PERSID] [nvarchar] (12) NOT NULL,
	[EXTDATATYPE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[EXTPERSID] [nvarchar] (20)  
) ON [PRIMARY]
GO

/* Table: DB_PERSNAME_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_PERSNAME_EFFDT] (
	[PERSID] [nvarchar] (12) NOT NULL,
	[NAMETYPE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[Educational Title] [nvarchar] (120)  
	[NAMEPREFIX] [nvarchar] (6),
	[INITIALS] [nvarchar] (12),
	[FIRSTNAME] [nvarchar] (30),
	[CALLINGNAME] [nvarchar] (30),
	[MIDDLENAMES] [nvarchar] (60),
	[NAMEINFIX] [nvarchar] (6),
	[LASTNAME] [nvarchar] (60),
	[NAMEPOSTFIX] [nvarchar] (6),
	[FULLNAME] [nvarchar] (120)  
) ON [PRIMARY]
GO

/* Table: DB_PERSON_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_PERSON_TBL] (
	[PERSID] [nvarchar] (12) NOT NULL,
	[GENDER] [nvarchar] (6),
	[NATIONALITY] [nvarchar] (6),
	[BIRTHDATE] [smalldatetime] NULL,
	[BIRTHTIME] [smalldatetime] NULL,
	[BIRTHCOUNTRY] [nvarchar] (6),
	[BIRTHPLACE] [nvarchar] (20),
	[DATEOFDEATH] [smalldatetime] NULL,
	[burgstaat] [nvarchar] (1),
	[NAMETYPEPREF] [nvarchar] (6),
	[ADDRTYPEPREF] [nvarchar] (6),
	[PHONETYPEPREF] [nvarchar] (6),
	[EMAILTYPEPREF] [nvarchar] (6)  
) ON [PRIMARY]
GO

/* Table: DB_PERSPHONE_DT, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_PERSPHONE_EFFDT] (
	[PERSID] [nvarchar] (12) NOT NULL,
	[PHONETYPE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[COUNTRY] [nvarchar] (6),
	[AREACODE] [nvarchar] (6),
	[LOCALCODE] [nvarchar] (12),
	[EXTENTIONCHARS] [smallint] NULL 
) ON [PRIMARY]
GO

/* Table: DB_POSTAL_REF, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_POSTAL_REF_TBL] (
	[COUNTRY] [nvarchar] (6) NOT NULL,
	[POSTAL] [nvarchar] (8) NOT NULL,
	[POSTAL_RANGE] [nvarchar] (6) NOT NULL,
	[POSTAL_BRKPNT_FROM] [int] NULL,
	[POSTAL_BRKPNT_UNTIL] [int] NULL,
	[POSTAL_STREET] [nvarchar] (30),
	[POSTAL_CITY] [nvarchar] (30),
	[POSTAL_STATE] [nvarchar] (6)  
) ON [PRIMARY]
GO

/* Table: DB_REGION, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_STATE_TBL] (
	[COUNTRY] [nvarchar] (6) NOT NULL,
	[STATE] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Table: DB_RELATIONSHIP_DT, Owner: SYSDBA */

/* Table: DB_ROOM_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_ROOM_TBL] (
	[BLDGID] [nvarchar] (12) NOT NULL,
	[ROOMID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[FLOOR] [int] NULL,
	[WING] [nvarchar] (6),
	[ROOM] [nvarchar] (6)  
) ON [PRIMARY]
GO

/* Table: DB_UNIT_TBL, Owner: SYSDBA */
CREATE TABLE [dbo].[DB_SECTION_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[SECTIONID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[DB_SUBDEPT_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[DEPTID] [nvarchar] (6) NOT NULL,
	[SUBDEPTID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[DB_SUBSECTION_TBL] (
	[ORGID] [nvarchar] (12) NOT NULL,
	[SECTIONID] [nvarchar] (6) NOT NULL,
	[SUBSECTIONID] [nvarchar] (6) NOT NULL,
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (64),
	[DESCRLONG] [varchar] (256),
	[DESCRLONG] [ntext],
	[DESCRTEXT] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Template DB: Temp Tables
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[TMP_IMPORTPERS] (
	[ACTOOLSID] [nvarchar] (12),
	[STAMNR] [nvarchar] (12),
	[PERSID] [nvarchar] (12),
	[TITELVOOR] [nvarchar] (50),
	[ROEPNAAM] [nvarchar] (50),
	[VOORNAAM] [nvarchar] (50),
	[VOORNAAM2] [nvarchar] (50),
	[VOORLETTERS] [nvarchar] (50),
	[TUSSENVOEGSEL] [nvarchar] (50),
	[ACHTERNAAM] [nvarchar] (50),
	[TITELNA] [nvarchar] (50),
	[TUSSENVPARTNER] [nvarchar] (50),
	[ACHTERNPARTNER] [nvarchar] (50),
	[PREFNAAM] [nvarchar] (50),
	[VOLLENAAM] [nvarchar] (50),
	[PREFTUSSENV] [varchar] (50) NULL,
	[PREFACHTERN] [varchar] (50) NULL,
	[GEBDATUM] [smalldatetime] NULL,
	[GESLACHT] [nvarchar] (50),
	[PRIVETELNR] [nvarchar] (50),
	[PRIVEADRES] [nvarchar] (50),
	[PRIVEHUISNR] [nvarchar] (50),
	[PRIVEPOSTCODE] [nvarchar] (50),
	[PRIVEWOONPLAATS] [nvarchar] (50),
	[BURGSTAAT] [nvarchar] (50),
	[MUTATIEDATUM] [smalldatetime] NULL,
	[SORTKENMERK] [nvarchar] (50),
	[FUNCTIETYPECODE] [nvarchar] (50),
	[FUNCTIETYPE] [nvarchar] (50),
	[FUNCTIECODE] [nvarchar] (50),
	[FUNCTIE] [nvarchar] (50),
	[STANDPLAATS] [nvarchar] (50),
	[STAMLOCATIE] [nvarchar] (50),
	[STAMUNIT] [nvarchar] (50),
	[SDVNR] [nvarchar] (50),
	[KOSTPLAATSCODE] [nvarchar] (50),
	[KOSTPLAATS] [nvarchar] (50),
	[KOSTFACTOR] [nvarchar] (50),
	[EMAIL] [nvarchar] (50),
	[WERKTELNR] [nvarchar] (50)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Template DB: Project Tables
-------------------------------------------------------------------------------

-- Project X: Undefined
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[AB_Base] (
	[stamnr] [nvarchar] (50) NULL,
	[dv_datum_einde] [nvarchar] (50) NULL,
	[datum] [nvarchar] (50) NULL,
	[burgstaat] [nvarchar] (1) NULL,
	[geslacht] [nvarchar] (5) NULL,
	[roepnaam] [nvarchar] (50) NULL,
	[naam] [nvarchar] (50) NULL,
	[gebdatum] [smalldatetime] NULL,
	[adres] [nvarchar] (50) NULL,
	[huisnr] [nvarchar] (50) NULL,
	[toevhuisnr] [nvarchar] (50) NULL,
	[postcode] [nvarchar] (50) NULL,
	[plaats] [nvarchar] (50) NULL,
	[TelnrPrive] [nvarchar] (50) NULL,
	[TelnrWerk] [nvarchar] (50) NULL,
	[afkorting] [nvarchar] (50) NULL,
	[functiecode] [nvarchar] (50) NULL,
	[functie] [nvarchar] (50) NULL,
	[SdvNr] [nvarchar] (50) NULL,
	[cso] [nvarchar] (50) NULL,
	[kpl] [nvarchar] (50) NULL,
	[factor] [nvarchar] (50) NULL,
	[locatie] [nvarchar] (50) NULL,
	[sortkenm] [nvarchar] (50) NULL,
	[OECODE_1] [nvarchar] (50) NULL,
	[LOCCODE_1] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_NAW] (
	[stamnr] [nvarchar] (50) NULL,
	[gebdatum] [smalldatetime] NULL,
	[EersteVoornaam] [nvarchar] (50) NULL,
	[OverigeVoornamen] [nvarchar] (50) NULL,
	[relatiecode] [nvarchar] (50) NULL,
	[voorl] [nvarchar] (50) NULL,
	[vvp] [nvarchar] (50) NULL,
	[NaamPartner] [nvarchar] (50) NULL,
	[vv] [nvarchar] (50) NULL,
	[eigennaam] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_SORT] (
	[sortkenmerk] [nvarchar] (50) NOT NULL,
	[afdeling] [nvarchar] (50) NULL,
	[locatie] [nvarchar] (50) NULL,
	[unit] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_SortKenmerk] (
	[sortkenmerk] [nvarchar] (50) NOT NULL,
	[afdeling] [nvarchar] (50) NULL,
	[locatie] [nvarchar] (50) NULL,
	[unit] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 1a: Telephone Inventory
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[X_AC_TEL_TOESTEL_TBL] (
	[TOESTEL_ID] [nvarchar] (6),
	[PHONETYPE] [nvarchar] (32)  
	[SHORTDESCR] [nvarchar] (12),
	[DESCR] [nvarchar] (32)  
	[SERIAL] [nvarchar] (32)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_UTP_OUTLET_TBL] (
	[LOK_ID] [nvarchar] (12),
	[KAMER_ID] [nvarchar] (6),
	[OUTLET_ID] [nvarchar] (12),
	[OUTLET_TYPE] [nvarchar] (6),
	[TELEFOONNR] [nvarchar] (12),
	[TOESTEL_ID] [nvarchar] (6),
	[PERS_ID] [nvarchar] (12)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PHONETYPE_TBL] (
	[PHONETYPE] [nvarchar] (32)  
	[NAME] [nvarchar] (20),
	[SHORTDESCR] [nvarchar] (12),
	[DESCR] [nvarchar] (32)  
	[BRAND] [nvarchar] (32)  
	[MODEL] [nvarchar] (32)  
	[CODE] [nvarchar] (32)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 1b: Telephone Inventory
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[X_AC_PERS_TEL_TBL] (
	[ATACID] [nvarchar] (12),
	[TELID] [int] NULL 
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[X_AC_TELEFOON_TBL] (
	[TELID] [int] NOT NULL,
	[TELTYPE] [nvarchar] (12),
	[KEYCODE] [nvarchar] (32),
	[KEYCODE2] [nvarchar] (32),
	[STATUS] [nvarchar] (5)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_TELEFOON_TYPE] (
	[TELTYPE] [nvarchar] (12),
	[MERK] [nvarchar] (20),
	[MODEL] [nvarchar] (20),
	[DESCR] [nvarchar] (60),
	[CODE] [nvarchar] (32)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 2: Project Management
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[X_AC_PROJECT_TBL] (
	[ORGID] [nvarchar] (50),
	[PROJECTID] [nvarchar] (50),
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[PERSID] [nvarchar] (50),
	[DESCRSHORT] [nvarchar] (50),
	[DESCR] [nvarchar] (50),
	[DESCRLONG] [nvarchar] (50)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJPLAN_TBL] (
	[ORGID] [nvarchar] (50),
	[PROJECTID] [nvarchar] (50),
	[PROJECTPLANID] [nvarchar] (50),
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[PERSID] [nvarchar] (50),
	[DESCRSHORT] [nvarchar] (50),
	[DESCR] [nvarchar] (50),
	[DESCRLONG] [nvarchar] (50)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJTASKPERS_TBL] (
	[ORGID] [nvarchar] (50),
	[PROJECTID] [nvarchar] (50),
	[PROJECTPLANID] [nvarchar] (50),
	[PROJECTTASKID] [nvarchar] (50),
	[PERSID] [nvarchar] (50),
	[STARTDT] [nvarchar] (50),
	[ENDDT] [nvarchar] (50),
	[TimeUnits=HOURS] [nvarchar] (50)  
	[TimeCount] [nvarchar] (50)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJTASK_TBL] (
	[ORGID] [nvarchar] (50),
	[PROJECTID] [nvarchar] (50),
	[PROJECTPLANID] [nvarchar] (50),
	[PROJECTTASKID] [nvarchar] (50),
	[EFFDT] [smalldatetime] NOT NULL,
	[EFFSTATUS] [nvarchar] (6),
	[DESCRSHORT] [nvarchar] (50),
	[DESCR] [nvarchar] (50),
	[DESCRLONG] [nvarchar] (50),
	[DEPTID] [nvarchar] (50),
	[SECTIONID] [nvarchar] (50),
	[TimeUnits=HOURS] [nvarchar] (50)  
	[TimeCount] [nvarchar] (50)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 3b: Personel Employment & Placing
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[_EXT_PERSONEEL] (
	[EXT_PERS_ID] [nvarchar] (12) NOT NULL,
	[ACTIEDATUM] [smalldatetime] NOT NULL,
	[STATUS] [nvarchar] (1),
	[VOORLETTERS] [nvarchar] (10),
	[VOORNAAM] [nvarchar] (30),
	[TUSSENVOEG] [nvarchar] (15),
	[ACHTERNAAM] [nvarchar] (30),
	[VOLLEDIGENAAM] [nvarchar] (60),
	[FUNCTIE] [nvarchar] (60),
	[SORTKENMERK] [nvarchar] (6),
	[SEXE] [nvarchar] (1),
	[PRIVETELNR] [nvarchar] (12),
	[BIRTHDATE] [smalldatetime] NULL 
	[AFDELING] [nvarchar] (10),
	[UNIT_ID] [nvarchar] (3),
	[FUNCTIE_ID] [nvarchar] (6),
	[LOKATIE_ID] [nvarchar] (4),
	[LASTUPDOPRID] [nvarchar] (8),
	[LASTUPDDTTM] [smalldatetime] NULL 
	[EMAIL] [nvarchar] (19) NOT NULL,
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 4a: Crebo Source Data
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[_CREBO_ADREST] (
	[BR98T] [nvarchar] (255),
	[SOORT] [nvarchar] (255),
	[NAAM] [nvarchar] (255),
	[KOR_STRAAT] [nvarchar] (255),
	[COR_NR] [nvarchar] (255),
	[KOR_PC] [nvarchar] (255),
	[KOR_WPL] [nvarchar] (255),
	[TELEF] [nvarchar] (255),
	[BRVES98] [nvarchar] (255),
	[VESSTR] [nvarchar] (255),
	[VES_NR] [nvarchar] (255),
	[VESPC] [nvarchar] (255),
	[VESWPL] [nvarchar] (255),
	[X] [nvarchar] (255),
	[Y] [nvarchar] (255)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_CREBO_BASIS_O] (
	[BR98T] [nvarchar] (255),
	[NAAM] [nvarchar] (255),
	[KW_SRT_KOR] [nvarchar] (255),
	[KW_SRT] [nvarchar] (255),
	[KW_NIV] [nvarchar] (255),
	[KWALC] [nvarchar] (255),
	[KWAL_NM] [nvarchar] (255),
	[WET_VER] [nvarchar] (255),
	[BEK] [nvarchar] (255),
	[PRIJSIND] [nvarchar] (255),
	[LWEG] [nvarchar] (255),
	[N_SBU] [nvarchar] (255),
	[DKWAL_CO] [nvarchar] (255),
	[DK_NAAM] [nvarchar] (255),
	[CATEG] [nvarchar] (255),
	[EXT] [nvarchar] (255)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_CREBO_BAS_T] (
	[RN_AFK] [nvarchar] (255),
	[LOBBR] [nvarchar] (255),
	[LOBNM] [nvarchar] (255),
	[OMS_SOPL] [nvarchar] (255),
	[NIVEAU] [nvarchar] (255),
	[KWALNAAM] [nvarchar] (255),
	[WET_VER] [nvarchar] (255),
	[KWALCODE] [nvarchar] (255),
	[BEKST] [nvarchar] (255),
	[PRIJSIND] [nvarchar] (255),
	[LEERWEG] [nvarchar] (255),
	[RN_DATBEG] [nvarchar] (255),
	[RN_DATEIN] [nvarchar] (255),
	[RN_DATSTOP] [nvarchar] (255),
	[SBU] [nvarchar] (255),
	[DKWALCODE] [nvarchar] (255),
	[DKWALNAAM] [nvarchar] (255),
	[CATEGORIE] [nvarchar] (255),
	[EXT_LEGIT] [nvarchar] (255)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_CREBO_C_ILIC] (
	[BR98T] [nvarchar] (255),
	[KWALC] [nvarchar] (255),
	[LW98T] [nvarchar] (255),
	[BEKOS] [nvarchar] (255)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 4b: Crebo Management
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[X_AC_CREBO_AANBOD] (
	[CREBO] [nvarchar] (6),
	[LEERWEG] [nvarchar] (3),
	[COHORT] [nvarchar] (6),
	[DATUM] [smalldatetime] NULL,
	[AANBOD_STATUS] [nvarchar] (6),
	[UNIT] [nvarchar] (6)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_CREBO_AANBOD_LOK] (
	[CREBO] [nvarchar] (6),
	[LEERWEG] [nvarchar] (3),
	[COHORT] [nvarchar] (6),
	[LOKATIE] [nvarchar] (6)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_CREBO_AANBOD_OER] (
	[CREBO] [nvarchar] (6),
	[LEERWEG] [nvarchar] (3),
	[COHORT] [nvarchar] (6),
	[DATUM] [smalldatetime] NULL,
	[OER_AANWEZIG] [bit] NOT NULL,
	[NETTO_SBU] [int] NULL,
	[STAGE_SBU] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_CREBO_LEERWEG_TBL] (
	[CREBO] [nvarchar] (6),
	[LEERWEG] [nvarchar] (3)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_CREBO_REGISTRATIE] (
	[CREBO] [nvarchar] (6),
	[LEERWEG] [nvarchar] (3),
	[DATUM] [smalldatetime] NULL,
	[REGISTRATIE_STATUS] [nvarchar] (6)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_CREBO_TBL] (
	[CREBO] [nvarchar] (6),
	[DATUM] [smalldatetime] NULL,
	[CREBOSTATUS] [nvarchar] (6),
	[VERVANG_CREBO] [nvarchar] (6),
	[OMSCHRIJVING] [nvarchar] (64),
	[KSB] [nvarchar] (6),
	[BRUTTO_SBU] [smallint] NULL,
	[LANDELIJK_ORGAAN] [nvarchar] (6)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_LANDELIJK_ORGAAN] (
	[LANDELIJK_ORGAAN] [nvarchar] (6),
	[OMSCHRIJVING] [nvarchar] (64)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_COHORT] (
	[COHORT] [nvarchar] (6) NOT NULL,
	[LEERWEG] [nvarchar] (3) NOT NULL,
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------

CREATE TABLE [dbo].[_RA] (
	[Id] [int] NOT NULL,
	[CODE PEOPLESOFT] [nvarchar] (255),
	[LEERWEG1] [nvarchar] (255),
	[LEERWEG2] [nvarchar] (255),
	[CREBONUMMER] [float] NULL,
	[KSB] [nvarchar] (255),
	[FORMELE_OMSCHRIJVING_CREBO] [nvarchar] (255),
	[LANGE OMSCHRIJVING PS] [nvarchar] (255),
	[KORTE OMSCHRIJVING PS] [nvarchar] (255),
	[x] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 5: DNS GEN - Server/Switch/Router Placement
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[_DEVICE_TBL] (
	[DEVID] [nvarchar] (12),
	[EFFDT] [smalldatetime] NULL,
	[EFFSTATUS] [nvarchar] (6),
	[ALIASOF] [nvarchar] (12),
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (32),
	[DESCRLONG] [nvarchar] (64)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_DNSLOCATIE_TBL] (
	[ORGID] [nvarchar] (12),
	[LOCID] [nvarchar] (12),
	[DNSLOCID] [nvarchar] (12),
	[EFFDT] [smalldatetime] NULL,
	[EFFSTATUS] [nvarchar] (50)  
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (32),
	[DESCRLONG] [nvarchar] (64)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_PLAATSEN_TBL] (
	[DEVID] [nvarchar] (12),
	[DNSLOCID] [nvarchar] (12),
	[EFFDT] [smalldatetime] NULL,
	[EFFSTATUS] [nvarchar] (50)  
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_TEKST_TBL] (
	[TEKSTID] [nvarchar] (12),
	[EFFDT] [smalldatetime] NULL,
	[EFFSTATUS] [nvarchar] (50)  
	[DESCRSHORT] [nvarchar] (12),
	[DESCR] [nvarchar] (32),
	[DESCRLONG] [nvarchar] (64)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 6: DB Automation
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[CONTROLELOGS] (
	[CTLDESCR] [varchar] (100),
	[DATUM] [datetime] NULL,
	[RESULT] [int] NULL,
	[RESDESCR] [varchar] (100)  
) ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Project 7: Import / Export Automation
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[TD_HARDWARE] (
	[objectid] [nvarchar] (30) NOT NULL,
	[configuratie] [nvarchar] (30),
	[budgethouder] [nvarchar] (30),
	[soort] [nvarchar] (30),
	[merk] [nvarchar] (30),
	[type] [nvarchar] (30),
	[specificatie] [nvarchar] (30),
	[installatie] [nvarchar] (30),
	[serienummer] [nvarchar] (30),
	[leverancier] [nvarchar] (60),
	[aanschaf] [datetime] NULL,
	[garantietot] [datetime] NULL,
	[verzekerdtot] [datetime] NULL,
	[aankoopbedrag] [money] NULL,
	[restwaarde] [money] NULL,
	[afschrijvenin] [int] NULL,
	[status] [nvarchar] (30),
	[ipadres] [nvarchar] (20),
	[hostnaam] [nvarchar] (20),
	[millenniumproof] [nvarchar] (30),
	[processor] [nvarchar] (30),
	[kloksnelheid] [nvarchar] (30),
	[hardeschijf] [nvarchar] (30),
	[partities] [int] NULL,
	[interngeheugen] [nvarchar] (30),
	[soortgeheugen] [nvarchar] (30),
	[geheugenbanken] [int] NULL,
	[ingebruik] [int] NULL,
	[diversen] [text],
	[merk1] [nvarchar] (30),
	[type1] [nvarchar] (30),
	[serienummer1] [nvarchar] (30),
	[merk2] [nvarchar] (30),
	[type2] [nvarchar] (30),
	[serienummer2] [nvarchar] (30),
	[merk3] [nvarchar] (30),
	[type3] [nvarchar] (30),
	[merk4] [nvarchar] (30),
	[type4] [nvarchar] (30),
	[merk5] [nvarchar] (30),
	[type5] [nvarchar] (30),
	[adres] [nvarchar] (30),
	[merk6] [nvarchar] (30),
	[type6] [nvarchar] (30),
	[baudrate] [nvarchar] (30),
	[type7] [nvarchar] (30),
	[merk7] [nvarchar] (30),
	[snelheid] [nvarchar] (30),
	[aantekeningen] [text],
	[tekst1] [nvarchar] (30),
	[tekst2] [nvarchar] (30),
	[tekst3] [nvarchar] (30),
	[tekst4] [nvarchar] (30),
	[tekst5] [nvarchar] (30),
	[opzoeklijst1] [nvarchar] (30),
	[opzoeklijst2] [nvarchar] (30),
	[opzoeklijst3] [nvarchar] (30),
	[getal1] [float] NULL,
	[getal2] [float] NULL,
	[datum1] [datetime] NULL,
	[datum2] [datetime] NULL,
	[logisch1] [bit] NULL,
	[logisch2] [bit] NULL,
	[logisch3] [bit] NULL,
	[logisch4] [bit] NULL,
	[logisch5] [bit] NULL,
	[aantekeningen1] [text],
	[aantekeningen2] [text]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[TD_PERSONEEL] (
	[personeeli] [nvarchar] (50) NOT NULL,
	[voornamen] [nvarchar] (30) NOT NULL,
	[achternaam] [nvarchar] (30) NOT NULL,
	[voorletters] [nvarchar] (10) NOT NULL,
	[tussenvoegsels] [nvarchar] (10),
	[vestiging] [nvarchar] (60),
	[locatie] [nvarchar] (30) NOT NULL,
	[afdeling] [nvarchar] (30) NOT NULL,
	[budgethouder] [nvarchar] (30) NOT NULL,
	[titel] [nvarchar] (10),
	[geslacht] [int] NULL,
	[functie] [nvarchar] (30),
	[personeelsnr] [nvarchar] (20),
	[mobiel] [nvarchar] (25),
	[telefoon] [nvarchar] (25),
	[fax] [nvarchar] (25),
	[email] [nvarchar] (50),
	[netwerk] [nvarchar] (30),
	[mainframe] [nvarchar] (30),
	[diversen] [ntext],
	[straat] [nvarchar] (50),
	[nr] [nvarchar] (6),
	[postcode] [nvarchar] (15),
	[plaats] [nvarchar] (30),
	[land] [nvarchar] (30),
	[email2] [nvarchar] (50),
	[geboren] [nvarchar] (10),
	[telefoon1] [nvarchar] (25),
	[telefoon2] [nvarchar] (25),
	[mobiel2] [nvarchar] (25),
	[fax2] [nvarchar] (25),
	[aantekeningen] [ntext],
	[tekst1] [nvarchar] (30),
	[tekst2] [nvarchar] (30),
	[tekst3] [nvarchar] (30),
	[tekst4] [nvarchar] (30),
	[tekst5] [nvarchar] (30),
	[opzoeklijst1] [nvarchar] (30),
	[opzoeklijst2] [nvarchar] (30),
	[opzoeklijst3] [nvarchar] (30),
	[getal1] [int] NULL,
	[getal2] [int] NULL,
	[datum1] [nvarchar] (10),
	[datum2] [nvarchar] (10),
	[logisch1] [int] NULL,
	[logisch2] [int] NULL,
	[logisch3] [int] NULL,
	[logisch4] [int] NULL,
	[logisch5] [int] NULL,
	[aantekeningen1] [ntext],
	[aantekeningen2] [ntext]  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-------------------------------------------------------------------------------
-- Finished:
-------------------------------------------------------------------------------

CREATE VIEW dbo.AC_PERSON_VW
AS
SELECT     dbo.AC_PERSON_TBL.PERSID AS EXPR1, dbo.AC_PERSNAME_EFFDT.NAMETYPE AS EXPR2, dbo.AC_PERSNAME_EFFDT.EFFDT AS EXPR3, 
                      dbo.AC_PERSNAME_EFFDT.EFFSTATUS AS EXPR4, dbo.AC_PERSNAME_EFFDT.CALLINGNAME AS EXPR5, 
                      dbo.AC_PERSNAME_EFFDT.LASTNAME AS EXPR6, dbo.AC_PERSPHONE_EFFDT.PHONETYPE AS EXPR7, 
                      dbo.AC_PERSPHONE_EFFDT.EFFDT AS EXPR8, dbo.AC_PERSPHONE_EFFDT.EFFSTATUS AS EXPR9, 
                      dbo.AC_PERSPHONE_EFFDT.COUNTRY AS EXPR10, dbo.AC_PERSPHONE_EFFDT.AREACODE AS EXPR11, 
                      dbo.AC_PERSPHONE_EFFDT.LOCALCODE AS EXPR12
FROM         dbo.AC_PERSON_TBL INNER JOIN
                      dbo.AC_PERSNAME_EFFDT ON dbo.AC_PERSON_TBL.PERSID = dbo.AC_PERSNAME_EFFDT.PERSID INNER JOIN
                      dbo.AC_PERSPHONE_EFFDT ON dbo.AC_PERSON_TBL.PERSID = dbo.AC_PERSPHONE_EFFDT.PERSID INNER JOIN
                      dbo.AC_PERSADDR_EFFDT ON dbo.AC_PERSON_TBL.PERSID = dbo.AC_PERSADDR_EFFDT.PERSID INNER JOIN
                      dbo.AC_PERSEMAIL_EFFDT ON dbo.AC_PERSON_TBL.PERSID = dbo.AC_PERSEMAIL_EFFDT.PERSID
WHERE     (dbo.AC_PERSNAME_EFFDT.CALLINGNAME LIKE 'H%') AND (dbo.AC_PERSNAME_EFFDT.LASTNAME LIKE 'W%')

CREATE PROCEDURE NEWORGID AS
DECLARE @ORGID_LAST VARCHAR(12)

BEGIN TRAN
UPDATE ACCONFIGBASE
SET ORGID_LAST = (SELECT (ORGID_LAST)+1 FROM ACCONFIGBASE);
SET @ORGID_LAST = (SELECT CONVERT(CHAR, ORGID_LAST) FROM ACCONFIGBASE)
COMMIT

WHILE (LEN(@ORGID_LAST) < 8)
BEGIN
  SET @ORGID_LAST = '0'+@ORGID_LAST
END
SELECT @ORGID_LAST AS NEWORGID
GO

CREATE PROCEDURE NEWPERSID AS
DECLARE @PERSID_LAST VARCHAR(12)

BEGIN TRAN
UPDATE ACCONFIGBASE
SET PERSID_LAST = (SELECT (PERSID_LAST)+1 FROM ACCONFIGBASE);
SET @PERSID_LAST = (SELECT CONVERT(CHAR, PERSID_LAST) FROM ACCONFIGBASE)
COMMIT

WHILE (LEN(@PERSID_LAST) < 8)
BEGIN
  SET @PERSID_LAST = '0'+@PERSID_LAST
END
SELECT @PERSID_LAST AS NEWPERSID
GO

CREATE view ACDW.ACTIEVE_DN
as
select AP.* 
from SA76PR2.dbo.PS_ACAD_PROG AP
where AP.PROG_ACTION='MATR'
and AP.EMPLID+'~'+ACAD_CAREER+'~'+cast(STDNT_CAR_NBR as varchar(10))+'~'+master.dbo.Dt2Char(AP.EFFDT,'YYYYMMDD')+'~'+cast(AP.EFFSEQ as varchar(3))=
   (select TOP 1 APS1.EMPLID+'~'+ACAD_CAREER+'~'+cast(STDNT_CAR_NBR as varchar(10))+'~'+master.dbo.Dt2Char(APS1.EFFDT,'YYYYMMDD')+'~'+cast(APS1.EFFSEQ as varchar(3))
       from SA76PR2.dbo.PS_ACAD_PROG APS1
       where APS1.EMPLID=AP.EMPLID
       order by STDNT_CAR_NBR desc,APS1.EFFDT DESC,APS1.EFFSEQ DESC ) 

GO

CREATE view ACDW.ACTIEVE_DN2
as
select AP.* 
from SA76PR2.dbo.PS_ACAD_PROG AP
where AP.PROG_ACTION='MATR'
and AP.EFFDT       =  
   (SELECT MAX(A1.EFFDT) FROM SA76PR2.dbo.PS_ACAD_PROG A1
    WHERE AP.EMPLID      =  A1.EMPLID
    AND AP.ACAD_CAREER   =  A1.ACAD_CAREER
    AND AP.STDNT_CAR_NBR =  A1.STDNT_CAR_NBR)
AND AP.EFFSEQ        =  
   (SELECT MAX(A2.EFFSEQ) FROM SA76PR2.dbo.PS_ACAD_PROG A2
    WHERE AP.EMPLID      =  A2.EMPLID
    AND AP.ACAD_CAREER   =  A2.ACAD_CAREER
    AND AP.STDNT_CAR_NBR =  A2.STDNT_CAR_NBR
    AND AP.EFFDT         =  A2.EFFDT)

GO

CREATE  view ACDW.ACTIEVE_DN_PERSINFO
as
select ADN.CAMPUS,  PDE.*, PD.BIRTHDATE, M.EMAILADRES
from SA76PR2.dbo.PS_PERS_DATA_EFFDT PDE 
join ACDW.ACTIEVE_DN ADN on PDE.EMPLID=ADN.EMPLID
join SA76PR2.dbo.PS_PERSONAL_DATA PD ON (PDE.EMPLID = PD.EMPLID) 
left join SRV_INTRA.ACMAIL.dbo.HISTORIE M ON (M.IDNUMMER='D00'+rtrim(PDE.EMPLID)) 
where PDE.EFFDT = (SELECT MAX(EFFDT) FROM SA76PR2.dbo.PS_PERS_DATA_EFFDT PDE2
		    WHERE PDE.EMPLID = PDE2.EMPLID)

GO

create view ACDW.AC_SYSJOBS as
select upper(j.name) NAME
, dateadd(ss,cast(substring(cast(run_time + 1000000   as char(7)),6,2) as int),
  dateadd(mi,cast(substring(cast(run_time + 1000000   as char(7)),4,2) as int),
  dateadd(hh,cast(substring(cast(run_time  + 1000000   as char(7)),2,2) as int),
  convert(datetime,cast(run_date as char(8)) ) ) )) START
, run_status RUN_STATUS
from msdb..sysjobs j
join msdb..sysjobhistory jh on j.job_id=jh.job_id
where jh.step_id=0

GO

create view ACDW.DN_PROGSTATUS
as select A.* 
from SA76PR2.dbo.PS_ACAD_PROG A,
     (	select A1.EMPLID, MAX(rtrim(A1.STDNT_CAR_NBR)+'~'+master.dbo.Dt2Char(A1.EFFDT,'YYYYMMDD')+rtrim(A1.EFFSEQ)) as maxkey
  	from SA76PR2.dbo.PS_ACAD_PROG A1
  	group by EMPLID ) B
where  A.EMPLID=B.EMPLID
and rtrim(A.STDNT_CAR_NBR)+'~'+master.dbo.Dt2Char(A.EFFDT,'YYYYMMDD')+rtrim(A.EFFSEQ)=B.maxkey

GO

CREATE   view ACDW.DN_STATUS
as
select PDE.*,DNS.ACAD_CAREER,DNS.STDNT_CAR_NBR,DNS.EFFDT as PROGEFFDT,DNS.EFFSEQ as PROGEFFSEQ,DNS.PROG_STATUS,DNS.PROG_ACTION,DNS.CAMPUS, DNS.ACAD_PROG, PD.BIRTHDATE, M.EMAILADRES
from SA76PR2.dbo.PS_PERS_DATA_EFFDT PDE 
join ACDW.DN_PROGSTATUS DNS on PDE.EMPLID=DNS.EMPLID
join SA76PR2.dbo.PS_PERSONAL_DATA PD ON (PDE.EMPLID = PD.EMPLID) 
left join SRV_INTRA.ACMAIL.dbo.HISTORIE M ON (M.IDNUMMER='D00'+rtrim(PDE.EMPLID)) 
where PDE.EFFDT = (SELECT MAX(EFFDT) FROM SA76PR2.dbo.PS_PERS_DATA_EFFDT PDE2
		    WHERE PDE.EMPLID = PDE2.EMPLID)

GO

--SELECT DISTINCT A.CAMPUS FROM PS_ACAD_PROG A ORDER BY 1
-- (DHUI, EMMN, HDBG, HGVN, KLUI, LEEK, RUYT, TRAV, VDAM, VECH, ZWOL)
--DECLARE @LOCATIE CHAR(12)
--SET @LOCATIE = 'HDBG'

--Import Script - Gebruik voor Nieuwe LLN en Update LLN
CREATE procedure dbo.AC_UImport_CAMPUS( @LOCATIE varchar(20))
as
 

SELECT RTRIM(A.EMPLID) as EMPLID, 
RTRIM(B.LAST_NAME) as LAST_NAME, 
RTRIM(B.FIRST_NAME)as FIRST_NAME, 
RTRIM(B.NAME)as FULL_NAME,  
RTRIM(AP.ACAD_ORG) +'-'+ RTRIM(A.ACAD_PROG) +'-'+ RTRIM(GN.STDNT_GROUP) +'-'+ RTRIM(GN.DESCR) +'-'+ RTRIM(A.CAMPUS) AS UNIT_OPL_GRPCD_GRP_LOC,
'.GR_'+ RTRIM(AP.ACAD_ORG)    +'.GROUPS.OW.'+ RTRIM(A.CAMPUS) +'.ALFA' as UNIT,
'.GR_'+ RTRIM(A.ACAD_PROG)    +'.GROUPS.OW.'+ RTRIM(A.CAMPUS) +'.ALFA' as OPLEIDING,
'.GR_'+ RTRIM(GN.STDNT_GROUP) +'.GROUPS.OW.'+ RTRIM(A.CAMPUS) +'.ALFA' as KLASCODE,
'.GR_'+ RTRIM(GN.DESCR)       +'.GROUPS.OW.'+ RTRIM(A.CAMPUS) +'.ALFA' as KLAS,
'.GR_'                        +'.GROUPS.OW.'+ RTRIM(A.CAMPUS) +'.ALFA' as SECTOR,
'.GR_'                        +'.GROUPS.OW.'+ RTRIM(A.CAMPUS) +'.ALFA' as NOGLEEG
FROM SA76PR2.dbo.PS_ACAD_PROG A
,   SA76PR2.dbo.PS_NAMES_VW B
,   SA76PR2.dbo.PS_STDNT_GROUP_TBL GN
,   SA76PR2.dbo.PS_STDNT_GRPS_HIST G
,   SA76PR2.dbo.PS_ACAD_PROG_TBL AP
WHERE A.EFFDT       =  
   (SELECT MAX(A1.EFFDT) FROM  SA76PR2.dbo.PS_ACAD_PROG A1
    WHERE A.EMPLID      =  A1.EMPLID
    AND A.ACAD_CAREER   =  A1.ACAD_CAREER
    AND A.STDNT_CAR_NBR =  A1.STDNT_CAR_NBR)
AND A.EFFSEQ        =  
   (SELECT MAX(A2.EFFSEQ) FROM  SA76PR2.dbo.PS_ACAD_PROG A2
    WHERE A.EMPLID      =  A2.EMPLID
    AND A.ACAD_CAREER   =  A2.ACAD_CAREER
    AND A.STDNT_CAR_NBR =  A2.STDNT_CAR_NBR
    AND A.EFFDT         =  A2.EFFDT)
AND G.EMPLID	    = A.EMPLID
AND G.EFFDT = 
    (SELECT MAX(G1.EFFDT) FROM  SA76PR2.dbo.PS_STDNT_GRPS_HIST G1
     WHERE G1.EMPLID=G.EMPLID
     AND G1.INSTITUTION = G.INSTITUTION)
AND G.EFF_STATUS='A'
AND GN.STDNT_GROUP      = G.STDNT_GROUP
AND GN.EFFDT = 
    (SELECT MAX(GN1.EFFDT) FROM  SA76PR2.dbo.PS_STDNT_GROUP_TBL GN1
     WHERE GN1.STDNT_GROUP=G.STDNT_GROUP )
AND GN.EFF_STATUS='A'
AND A.INSTITUTION   =  AP.INSTITUTION
AND A.ACAD_PROG     =  AP.ACAD_PROG
AND AP.EFFDT        =  (SELECT MAX(AP1.EFFDT) FROM  SA76PR2.dbo.PS_ACAD_PROG_TBL AP1
    WHERE AP.INSTITUTION =  AP1.INSTITUTION
    AND   AP.ACAD_PROG   =  AP1.ACAD_PROG)
AND A.PROG_ACTION   IN ('MATR') --,'WADM','COMP'
AND A.CAMPUS        =  @LOCATIE 
AND A.EMPLID        =  B.EMPLID
AND B.NAME_TYPE     =  'PRF'
ORDER BY RIGHT(RTRIM(A.EMPLID), 1), 1
GO


-------------------------------------------------------------------------------
-- Table Content: FIELDDEFN
-------------------------------------------------------------------------------

FIELDNAME				TYPE
-------------------------------------	-------------------------------------
ACCESSENCCD		NVARCHAR(6)
ACCESSID			NVARCHAR(12)
ACCESSSECPW		NVARCHAR(24)
ACTIONID			NVARCHAR(12)
ADDRTYPE			NVARCHAR(6)
ALTSEARCHFIELD		BOOLEAN
BEGINDT			DATETIME
BIRTHDATE			DATETIME
BIRTHTIME			DATETIME
BLDGID			NVARCHAR(12)
CALLINGNAME			NVARCHAR(32)
CITY				NVARCHAR(32)
CONID				NVARCHAR(12)
CONLOGIN			NVARCHAR(12)
CONPW			NVARCHAR(24)
CONSOURCE			NVARCHAR(64)
CONTYPE			NVARCHAR(6)?COUNTRY			NVARCHAR(12)
CURRENCY			NVARCHAR(6)
DATECOUNT			NVARCHAR(12)
DATEOFDEATH		DATETIME
DATEUNITS			NVARCHAR(6)
DEFAULTVALUE		NVARCHAR(12)
DEPTID			NVARCHAR(12)
DECIMALS			INTEGER
DESCR				NVARCHAR(64)
DESCRLONG			NVARCHAR(255)
DESCRSHORT			NVARCHAR(12)
DREFTYPE			NVARCHAR(6)
EDUCATIONALTITLE		NVARCHAR(12)
EFFDT				DATETIME
EFFSTATUS			NVARCHAR(6)
EMAIL				NVARCHAR(32)
EMAILTYPE			NVARCHAR(6)
ENCRYPTCD			NVARCHAR(6)
ENDDT				DATETIME
EXCHANGEBUNDLE		NVARCHAR(12)
EXCHANGERATE		NVARCHAR(12)
EXTDATATYPE		NVARCHAR(6)
FIELDNAME			NVARCHAR(24)
FIELDSIZE			INTEGER
FIELDTYPE			NVARCHAR(6)
FIRSTNAME			NVARCHAR(32)
FLOOR				INTEGER
FULLNAME			NVARCHAR(128)
FUNCTIONID			NVARCHAR(12)
GENDER			NVARCHAR(6)
INITIALS			NVARCHAR(12)
KEYFIELD			BOOLEAN
LANGUAGECD			NVARCHAR(12)
LASTNAME			NVARCHAR(32)
LASTUPDDTTM		DATETIME
LISTBOXITEM			BOOLEAN
LOCID				NVARCHAR(12)
MIDDLENAMES		NVARCHAR(64)

-------------------------------------------------------------------------------
-- Table Content: FIELDDEFN: ALIASOF FIELD
-------------------------------------------------------------------------------

FIELDNAME				TYPE
-------------------------------------	-------------------------------------
NAMEINFIX			NVARCHAR(12)
NAMEPOSTFIX			NVARCHAR(12)
NAMEPREFIX			NVARCHAR(12)
NAMETYPE			NVARCHAR(6)
NATIONALITY			NVARCHAR(12)
NR1				NVARCHAR(12)
NR2				NVARCHAR(12)
ORGID				NVARCHAR(12)
OPRID				NVARCHAR(12)
OPRTYPE			NVARCHAR(6)
OUTLETID			NVARCHAR(12)
OUTLETTYPE			NVARCHAR(6)
PERSID			NVARCHAR(12)
PHONETYPE			NVARCHAR(6)
POSTAL			NVARCHAR(12)?POSTAL_BRKPNT_FROM	INTEGER
POSTAL_BRKPNT_UNTIL	INTEGER
POSTAL_RANGE		NVARCHAR(6)
PROJECTID			NVARCHAR(12)
PROJPLANID			NVARCHAR(12)
PROJTASKID			NVARCHAR(12)
RECNAME			NVARCHAR(12)
RECTYPE			NVARCHAR(6)
REQUIRED			BOOLEAN
ROOMID			NVARCHAR(12)
ROOMNR			NVARCHAR(6)
SCHEDID			NVARCHAR(12)
SEARCHFIELD			BOOLEAN
SECTIONID			NVARCHAR(12)
SECURITY_PW		NVARCHAR(24)
SEQUENCENR			INTEGER
SQLACTIONID			NVARCHAR(12)
SQLSTMNT			NVARCHAR(255)
SQLTABLE			NVARCHAR(24)
STATE				NVARCHAR(12)
STREET			NVARCHAR(32)
SUBDEPTID			NVARCHAR(12)
SUBSECTID			NVARCHAR(12)
TELEPHONE			NVARCHAR(12)
TIMECOUNT			NVARCHAR(12)
TIMEUNITS			NVARCHAR(6)
TOESTELID
VERSION			INTEGER
WING				NVARCHAR(6)

-------------------------------------------------------------------------------
-- Table Content: FIELDVALUE
-------------------------------------------------------------------------------

FIELDNAME				ALIASOF
-------------------------------------	-------------------------------------
ADDRTYPEPREF		ADDRTYPE
BIRTHCOUNTRY		COUNTRY
BIRTHPLACE			CITY
CONTACT			PERSID
CURRENCY_BASE		CURRENCY
DREFREC			RECNAME
DREFRECFIELD		FIELDNAME
EMAILTYPEPREF		EMAILTYPE
EXTPERSID			PERSID
HEADOFFICE			LOCID
LANGUAGE_BASE		LANGUAGECD
LASTUPDOPRID		OPRID
NAMETYPEPREF		NAMETYPE
ORGID_LAST			ORGID
OPRGRPPREF			OPRID
PAREBTREC			RECNAME
PERSID_LAST			PERSID
POSTAL_STREET		STREET
POSTAL_CITY			CITY
POSTAL_STATE		STATE
PHONETYPEPREF		PHONETYPE
SEARCHREC			RECNAME


FIELDNAME				FIELDVALUE			DESCR
-------------------------------------	-------------------------------------	-------------------------------------
ACCESSENCCD		0				PLANE TEXT
ACCESSENCCD		1				1ST ENCODE
ADDRTYPE			BILL				-
ADDRTYPE			HOME				-
ADDRTYPE			POST				-
ADDRTYPE			WORK				-
CONTYPE			D				DELETE
CONTYPE			E				EXECUTE
CONTYPE			I				INSERT
CONTYPE			S				SELECT
CONTYPE			U				UPDATE
DATEUNITS			DAY				DAY(S)
DATEUNITS			WEEK				WEEK(S)
DATEUNITS			MONTH			MONTH(S)
DATEUNITS			YEAR				YEAR(S)
DREFTYPE			NONE				-
DREFTYPE			RECORD			REFERENCE RECORD
DREFTYPE			FLDVAL			FIELDVALUE REF
DREFTYPE			YESNO				YES/NO
EFFSTATUS			A				ACTIVE
EFFSTATUS			I				INACTIVE
EMAILTYPE			HOME				-
EMAILTYPE			INTER				-
EMAILTYPE			WORK				-
ENCRYPTCD			0				PLANE TEXT
ENCRYPTCD			1				1ST ENCODE
EXTDATATYPE		ATAC				EXTERNAL SOURCE
EXTDATATYPE		EDUKAT			EXTERNAL SOURCE
EXTDATATYPE		EXACT				EXTERNAL SOURCE
EXTDATATYPE		PSOFT				EXTERNAL SOURCE
FIELDTYPE			BLOB
FIELDTYPE			CHAR
FIELDTYPE			DATE
FIELDTYPE			DTTM
FIELDTYPE			INTEGER
FIELDTYPE			TEXT
FIELDTYPE			TIME
GENDER			F				FEMALE
GENDER			M				MALE
GENDER			U				UNKNOWN
NAMETYPE			BIRTH				-
NAMETYPE			COMMON			-
NAMETYPE			MARRIED			-
OPRTYPE			OPR				OPERATOR
OPRTYPE			OPRGRP			OPERATOR GROEP
ORGTYPE			SCHOOL			SCHOOL
ORGTYPE			STAGE				STAGE
OUTLETTYPE			D				DATA
OUTLETTYPE			I				ISDN
OUTLETTYPE			T1				T1 / ISDN2
OUTLETTYPE			A				ANALOOG
PHONETYPE			HOME				-
PHONETYPE			WORK				-
PHONETYPE			GSM				-
PHONETYPE			GSMWORK			-
POSTAL_RANGE		0				EVEN NUMBERS
POSTAL_RANGE		1				ODD NUMBERS
RECTYPE			T				TABLE
RECTYPE			VW				VIEW
RECTYPE			SP				STORED PROCEDURE
TIMEUNITS			SECOND			SECOND(S)
TIMEUNITS			MINUTE			MINUTE(S)
TIMEUNITS			HOUR				HOUR(S)
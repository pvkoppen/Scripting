if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[NEWORGID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NEWORGID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[NEWPERSID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NEWPERSID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACACCESSDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACACCESSDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACACTIONDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACACTIONDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACACTIONITEMS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACACTIONITEMS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACCONDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACCONDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACCONFIGBASE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACCONFIGBASE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACCONSQLDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACCONSQLDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACFIELDDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACFIELDDEFN_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDDEFN_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACOPRDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACOPRDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACRECDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACRECDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACRECDEFN_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACRECDEFN_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACRECFIELD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACRECFIELD]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACREFVALUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACREFVALUE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACREFVALUE_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACREFVALUE_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACSCHEDULE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACSCHEDULE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTMP_IMPORTPERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTMP_IMPORTPERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_BUILDING_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_BUILDING_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_COUNTRY_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_COUNTRY_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_COUNTRY_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_COUNTRY_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_DEPARTMENT_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_DEPARTMENT_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_EMPLOYMENT_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_EMPLOYMENT_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_EXTERNALPERSID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_EXTERNALPERSID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_FUNCTION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_FUNCTION_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_LANGUAGE_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_LANGUAGE_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_LOCATION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_LOCATION_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NAMEINFIX_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NAMEINFIX_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NAMEINFIX_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NAMEINFIX_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NAMEPREFIX_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NAMEPREFIX_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NAMEPREFIX_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NAMEPREFIX_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NAMESUFFIX_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NAMESUFFIX_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NAMESUFFIX_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NAMESUFFIX_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NATIONALITY_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NATIONALITY_LNG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_NATIONALITY_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_NATIONALITY_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_ORGANIZATION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_ORGANIZATION_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_ORG_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_ORG_TYPE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_PERSADDR_EFFDT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_PERSADDR_EFFDT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_PERSEMAIL_EFFDT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_PERSEMAIL_EFFDT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_PERSNAME_EFFDT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_PERSNAME_EFFDT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_PERSON_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_PERSON_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_PERSPHONE_EFFDT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_PERSPHONE_EFFDT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_POSTAL_REF_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_POSTAL_REF_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_ROOM_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_ROOM_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_SECTION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_SECTION_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_STATE_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_STATE_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_SUBDEPT_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_SUBDEPT_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_SUBSECTION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_SUBSECTION_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[X_AC2_TEL_TOESTEL_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[X_AC2_TEL_TOESTEL_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[X_AC2_UTP_OUTLET_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[X_AC2_UTP_OUTLET_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[X_AC_PROJECT_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[X_AC_PROJECT_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[X_AC_PROJPLAN_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[X_AC_PROJPLAN_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[X_AC_PROJTASKPERS_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[X_AC_PROJTASKPERS_TBL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[X_AC_PROJTASK_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[X_AC_PROJTASK_TBL]
GO

CREATE TABLE [dbo].[ACACCESSDEFN] (
	[ACCESSID] [varchar] (8) NOT NULL ,
	[ACCESSENCCD] [varchar] (6) NULL ,
	[ACCESSSECPW] [varchar] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACACTIONDEFN] (
	[ACTIONID] [varchar] (12) NOT NULL ,
	[SCHEDID] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACACTIONITEMS] (
	[ACTIONID] [varchar] (12) NOT NULL ,
	[SEQUENCENR] [varchar] (6) NOT NULL ,
	[CONID] [varchar] (12) NULL ,
	[SQLACTIONID] [varchar] (12) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACCONDEFN] (
	[CONID] [varchar] (12) NOT NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[CONTYPE] [varchar] (6) NULL ,
	[CONSOURCE] [varchar] (64) NULL ,
	[CONLOGIN] [varchar] (12) NULL ,
	[CONPW] [varchar] (12) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACCONFIGBASE] (
	[PERSID_LAST] [varchar] (12) NULL ,
	[LANGUAGE_BASE] [varchar] (6) NULL ,
	[CURRENCY_BASE] [varchar] (6) NULL ,
	[ORGID_LAST] [varchar] (12) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACCONSQLDEFN] (
	[CONID] [varchar] (12) NOT NULL ,
	[SQLACTIONID] [varchar] (12) NOT NULL ,
	[SQLSTTMNT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACFIELDDEFN] (
	[FIELDNAME] [varchar] (20) NOT NULL ,
	[VERSION] [int] NULL ,
	[FIELDTYPE] [varchar] (6) NULL ,
	[FIELDSIZE] [varchar] (3) NULL ,
	[DECIMALS] [varchar] (2) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRTEXT] [text] NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACFIELDDEFN_LNG] (
	[FIELDNAME] [varchar] (20) NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRTEXT] [text] NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACOPRDEFN] (
	[OPRID] [varchar] (8) NOT NULL ,
	[OPRTYPE] [varchar] (6) NULL ,
	[PERSID] [varchar] (12) NULL ,
	[NAME] [varchar] (60) NULL ,
	[ENCRYPTCD] [varchar] (6) NULL ,
	[SECURITY_PW] [varchar] (20) NULL ,
	[ACCESSID] [varchar] (8) NULL ,
	[ACCESSENCCD] [varchar] (6) NULL ,
	[ACCESSSECPW] [varchar] (20) NULL ,
	[OPRGRPPREF] [varchar] (8) NULL ,
	[LANGUAGECD] [varchar] (6) NULL ,
	[DESCRTEXT] [text] NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACRECDEFN] (
	[RECNAME] [varchar] (17) NOT NULL ,
	[VERSION] [int] NULL ,
	[RECTYPE] [varchar] (6) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRTEXT] [text] NULL ,
	[PARENTREC] [varchar] (17) NULL ,
	[SEARCHREC] [varchar] (17) NULL ,
	[SQLTABLE] [varchar] (20) NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACRECDEFN_LNG] (
	[RECNAME] [varchar] (17) NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRTEXT] [text] NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACRECFIELD] (
	[RECNAME] [varchar] (17) NOT NULL ,
	[FIELDNAME] [varchar] (20) NOT NULL ,
	[SEQNUMBER] [int] NULL ,
	[KEYFIELD] [varchar] (1) NULL ,
	[SEARCHFIELD] [varchar] (1) NULL ,
	[ALTSEARCHFIELD] [varchar] (1) NULL ,
	[LISTBOXITEM] [varchar] (1) NULL ,
	[REQUIRED] [varchar] (1) NULL ,
	[DREFTYPE] [varchar] (6) NULL ,
	[DREFREC] [varchar] (17) NULL ,
	[DREFRECFIELD] [varchar] (20) NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACREFVALUE] (
	[FIELDNAME] [varchar] (20) NOT NULL ,
	[FIELDVALUE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACREFVALUE_LNG] (
	[FIELDNAME] [varchar] (20) NOT NULL ,
	[FIELDVALUE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACSCHEDULE] (
	[SCHEDID] [varchar] (12) NOT NULL ,
	[SCHEDTYPE] [varchar] (6) NULL ,
	[SCHEDDATE] [datetime] NULL ,
	[SCHEDTIME] [datetime] NULL ,
	[SCHEDDAY] [varchar] (6) NULL ,
	[SCHEDWEEK] [varchar] (6) NULL ,
	[SCHEDMONTH] [varchar] (6) NULL ,
	[SCHEDYEAR] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTMP_IMPORTPERS] (
	[ACTOOLSID] [varchar] (12) NULL ,
	[STAMNR] [varchar] (12) NULL ,
	[PERSID] [varchar] (12) NULL ,
	[TITELVOOR] [varchar] (50) NULL ,
	[ROEPNAAM] [varchar] (50) NULL ,
	[VOORNAAM] [varchar] (50) NULL ,
	[VOORNAAM2] [varchar] (50) NULL ,
	[VOORLETTERS] [varchar] (50) NULL ,
	[TUSSENVOEGSEL] [varchar] (50) NULL ,
	[ACHTERNAAM] [varchar] (50) NULL ,
	[TITELNA] [varchar] (50) NULL ,
	[TUSSENVPARTNER] [varchar] (50) NULL ,
	[ACHTERNPARTNER] [varchar] (50) NULL ,
	[PREFNAAM] [varchar] (50) NULL ,
	[VOLLENAAM] [varchar] (50) NULL ,
	[GEBDATUM] [datetime] NULL ,
	[GESLACHT] [varchar] (50) NULL ,
	[PRIVETELNR] [varchar] (50) NULL ,
	[PRIVEADRES] [varchar] (50) NULL ,
	[PRIVEHUISNR] [varchar] (50) NULL ,
	[PRIVEPOSTCODE] [varchar] (50) NULL ,
	[PRIVEWOONPLAATS] [varchar] (50) NULL ,
	[BURGSTAAT] [varchar] (50) NULL ,
	[MUTATIEDATUM] [datetime] NULL ,
	[SORTKENMERK] [varchar] (50) NULL ,
	[FUNCTIETYPECODE] [varchar] (50) NULL ,
	[FUNCTIETYPE] [varchar] (50) NULL ,
	[FUNCTIECODE] [varchar] (50) NULL ,
	[FUNCTIE] [varchar] (50) NULL ,
	[STANDPLAATS] [varchar] (50) NULL ,
	[STAMLOCATIE] [varchar] (50) NULL ,
	[STAMUNIT] [varchar] (50) NULL ,
	[SDVNR] [varchar] (50) NULL ,
	[KOSTPLAATSCODE] [varchar] (50) NULL ,
	[KOSTPLAATS] [varchar] (50) NULL ,
	[KOSTFACTOR] [varchar] (50) NULL ,
	[EMAIL] [varchar] (50) NULL ,
	[WERKTELNR] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_BUILDING_TBL] (
	[BLDGID] [varchar] (12) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_COUNTRY_LNG] (
	[COUNTRY] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_COUNTRY_TBL] (
	[COUNTRY] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_DEPARTMENT_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[DEPTID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_EMPLOYMENT_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[PERSID] [varchar] (12) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DEPTID] [varchar] (6) NULL ,
	[SUBDEPTID] [varchar] (6) NULL ,
	[SECTIONID] [varchar] (6) NULL ,
	[SUBSECTIONID] [varchar] (6) NULL ,
	[LOCID] [varchar] (6) NULL ,
	[BLDGID] [varchar] (12) NULL ,
	[ROOMID] [varchar] (6) NULL ,
	[FUNCTIONID] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_EXTERNALPERSID] (
	[PERSID] [varchar] (12) NOT NULL ,
	[EXTDATATYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[EXTPERSID] [varchar] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_FUNCTION_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[FUNCTIONID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_LANGUAGE_TBL] (
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_LOCATION_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[LOCID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEINFIX_LNG] (
	[NAMEINFIX] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEINFIX_TBL] (
	[NAMEINFIX] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEPREFIX_LNG] (
	[NAMEPREFIX] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEPREFIX_TBL] (
	[NAMEPREFIX] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMESUFFIX_LNG] (
	[NAMESUFFIX] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMESUFFIX_TBL] (
	[NAMESUFFIX] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NATIONALITY_LNG] (
	[NATIONALITY] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NATIONALITY_TBL] (
	[NATIONALITY] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_ORGANIZATION_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL ,
	[HEADOFFICE] [varchar] (6) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_ORG_TYPE] (
	[ORGID] [varchar] (12) NOT NULL ,
	[ORGTYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSADDR_EFFDT] (
	[PERSID] [varchar] (12) NOT NULL ,
	[ADDRTYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[COUNTRY] [varchar] (6) NULL ,
	[STREET] [varchar] (30) NULL ,
	[NR1] [varchar] (6) NULL ,
	[NR2] [varchar] (6) NULL ,
	[POSTAL] [varchar] (8) NULL ,
	[CITY] [varchar] (30) NULL ,
	[STATE] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSEMAIL_EFFDT] (
	[PERSID] [varchar] (12) NOT NULL ,
	[EMAILTYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[EMAIL] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSNAME_EFFDT] (
	[PERSID] [varchar] (12) NOT NULL ,
	[NAMETYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[NAMEPREFIX] [varchar] (6) NULL ,
	[INITIALS] [varchar] (12) NULL ,
	[CALLINGNAME] [varchar] (30) NULL ,
	[FIRSTNAME] [varchar] (30) NULL ,
	[MIDDLENAMES] [varchar] (60) NULL ,
	[NAMEINFIX] [varchar] (6) NULL ,
	[LASTNAME] [varchar] (60) NULL ,
	[NAMESUFFIX] [varchar] (6) NULL ,
	[FULLNAME] [varchar] (120) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSON_TBL] (
	[PERSID] [varchar] (12) NOT NULL ,
	[GENDER] [varchar] (6) NULL ,
	[NATIONALITY] [varchar] (6) NULL ,
	[BIRTHDATE] [datetime] NULL ,
	[BIRTHTIME] [datetime] NULL ,
	[BIRTHCOUNTRY] [varchar] (6) NULL ,
	[BIRTHPLACE] [varchar] (20) NULL ,
	[DATEOFDEATH] [datetime] NULL ,
	[NAMETYPEPREF] [varchar] (6) NULL ,
	[ADDRTYPEPREF] [varchar] (6) NULL ,
	[PHONETYPEPREF] [varchar] (6) NULL ,
	[EMAILTYPEPREF] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSPHONE_EFFDT] (
	[PERSID] [varchar] (12) NOT NULL ,
	[PHONETYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[COUNTRY] [varchar] (6) NULL ,
	[AREACODE] [varchar] (6) NULL ,
	[LOCALCODE] [varchar] (12) NULL ,
	[EXTENTIONCHARS] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_POSTAL_REF_TBL] (
	[COUNTRY] [varchar] (6) NOT NULL ,
	[POSTAL] [varchar] (8) NOT NULL ,
	[POSTAL_RANGE] [varchar] (6) NOT NULL ,
	[POSTAL_BRKPNT_FROM] [int] NULL ,
	[POSTAL_BRKPNT_UNTIL] [int] NULL ,
	[POSTAL_STREET] [varchar] (30) NULL ,
	[POSTAL_CITY] [varchar] (30) NULL ,
	[POSTAL_STATE] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_ROOM_TBL] (
	[BLDGID] [varchar] (12) NOT NULL ,
	[ROOMID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[FLOOR] [int] NULL ,
	[WING] [varchar] (6) NULL ,
	[ROOM] [varchar] (6) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_SECTION_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[SECTIONID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_STATE_TBL] (
	[COUNTRY] [varchar] (6) NOT NULL ,
	[STATE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_SUBDEPT_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[DEPTID] [varchar] (6) NOT NULL ,
	[SUBDEPTID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_SUBSECTION_TBL] (
	[ORGID] [varchar] (12) NOT NULL ,
	[SECTIONID] [varchar] (6) NOT NULL ,
	[SUBSECTIONID] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL ,
	[DESCRTEXT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC2_TEL_TOESTEL_TBL] (
	[TOESTEL_ID] [varchar] (6) NULL ,
	[NAME] [varchar] (20) NULL ,
	[SHORTDESCR] [varchar] (12) NULL ,
	[DESCR] [varchar] (32) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC2_UTP_OUTLET_TBL] (
	[LOK_ID] [varchar] (12) NULL ,
	[KAMER_ID] [varchar] (6) NULL ,
	[OUTLET_ID] [varchar] (12) NULL ,
	[OUTLET_TYPE] [varchar] (6) NULL ,
	[TELEFOONNR] [varchar] (12) NULL ,
	[TOESTEL_ID] [varchar] (6) NULL ,
	[PERS_ID] [varchar] (12) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJECT_TBL] (
	[PROJECTID] [varchar] (50) NULL ,
	[PERSID] [varchar] (50) NULL ,
	[DESCRSHORT] [varchar] (50) NULL ,
	[DESCR] [varchar] (50) NULL ,
	[DESCRLONG] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJPLAN_TBL] (
	[PROJECTID] [varchar] (50) NULL ,
	[PROJECTPLANID] [varchar] (50) NULL ,
	[PERSID] [varchar] (50) NULL ,
	[DESCRSHORT] [varchar] (50) NULL ,
	[DESCR] [varchar] (50) NULL ,
	[DESCRLONG] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJTASKPERS_TBL] (
	[PROJECTID] [varchar] (50) NULL ,
	[PROJECTPLANID] [varchar] (50) NULL ,
	[PROJECTTASKID] [varchar] (50) NULL ,
	[PERSID] [varchar] (50) NULL ,
	[STARTDT] [varchar] (50) NULL ,
	[ENDDT] [varchar] (50) NULL ,
	[HOURS] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJTASK_TBL] (
	[PROJECTID] [varchar] (50) NULL ,
	[PROJECTPLANID] [varchar] (50) NULL ,
	[PROJECTTASKID] [varchar] (50) NULL ,
	[DESCRSHORT] [varchar] (50) NULL ,
	[DESCR] [varchar] (50) NULL ,
	[DESCRLONG] [varchar] (50) NULL ,
	[SECTIONID] [varchar] (50) NULL ,
	[HOURS] [varchar] (50) NULL 
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


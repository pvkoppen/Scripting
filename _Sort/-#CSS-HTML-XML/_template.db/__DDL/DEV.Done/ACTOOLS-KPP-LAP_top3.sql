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
	[ACCESSID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ACCESSENCCD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACCESSSECPW] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACACTIONDEFN] (
	[ACTIONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SCHEDID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACACTIONITEMS] (
	[ACTIONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SEQUENCENR] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SQLACTIONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACCONDEFN] (
	[CONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CONTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CONSOURCE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CONLOGIN] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CONPW] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACCONFIGBASE] (
	[PERSID_LAST] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LANGUAGE_BASE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CURRENCY_BASE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ORGID_LAST] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACCONSQLDEFN] (
	[CONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SQLACTIONID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SQLSTTMNT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACFIELDDEFN] (
	[FIELDNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[VERSION] [int] NULL ,
	[FIELDTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FIELDSIZE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DECIMALS] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACFIELDDEFN_LNG] (
	[FIELDNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACOPRDEFN] (
	[OPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[OPRTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ENCRYPTCD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SECURITY_PW] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACCESSID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACCESSENCCD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACCESSSECPW] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OPRGRPPREF] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACRECDEFN] (
	[RECNAME] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[VERSION] [int] NULL ,
	[RECTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PARENTREC] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SEARCHREC] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SQLTABLE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACRECDEFN_LNG] (
	[RECNAME] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACRECFIELD] (
	[RECNAME] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FIELDNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SEQNUMBER] [int] NULL ,
	[KEYFIELD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SEARCHFIELD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ALTSEARCHFIELD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LISTBOXITEM] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[REQUIRED] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DREFTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DREFREC] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DREFRECFIELD] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACREFVALUE] (
	[FIELDNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FIELDVALUE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACREFVALUE_LNG] (
	[FIELDNAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FIELDVALUE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACSCHEDULE] (
	[SCHEDID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SCHEDTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SCHEDDATE] [datetime] NULL ,
	[SCHEDTIME] [datetime] NULL ,
	[SCHEDDAY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SCHEDWEEK] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SCHEDMONTH] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SCHEDYEAR] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTMP_IMPORTPERS] (
	[ACTOOLSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STAMNR] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TITELVOOR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ROEPNAAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TUSSENVOEGSEL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TITELNA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TUSSENVPARTNER] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNPARTNER] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PREFNAAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLENAAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GEBDATUM] [datetime] NULL ,
	[GESLACHT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVETELNR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVEADRES] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVEHUISNR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVEPOSTCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVEWOONPLAATS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BURGSTAAT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MUTATIEDATUM] [datetime] NULL ,
	[SORTKENMERK] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIETYPECODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIETYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIECODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STANDPLAATS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STAMLOCATIE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STAMUNIT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SDVNR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[KOSTPLAATSCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[KOSTPLAATS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[KOSTFACTOR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAIL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WERKTELNR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_BUILDING_TBL] (
	[BLDGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_COUNTRY_LNG] (
	[COUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_COUNTRY_TBL] (
	[COUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_DEPARTMENT_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DEPTID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_EMPLOYMENT_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DEPTID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SUBDEPTID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SECTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SUBSECTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BLDGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ROOMID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_EXTERNALPERSID] (
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EXTDATATYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EXTPERSID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_FUNCTION_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FUNCTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_LANGUAGE_TBL] (
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_LOCATION_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LOCID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEINFIX_LNG] (
	[NAMEINFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEINFIX_TBL] (
	[NAMEINFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEPREFIX_LNG] (
	[NAMEPREFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMEPREFIX_TBL] (
	[NAMEPREFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMESUFFIX_LNG] (
	[NAMESUFFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NAMESUFFIX_TBL] (
	[NAMESUFFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NATIONALITY_LNG] (
	[NATIONALITY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_NATIONALITY_TBL] (
	[NATIONALITY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_ORGANIZATION_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HEADOFFICE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_ORG_TYPE] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ORGTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSADDR_EFFDT] (
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ADDRTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STREET] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NR1] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NR2] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[POSTAL] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSEMAIL_EFFDT] (
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EMAILTYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAIL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSNAME_EFFDT] (
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NAMETYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAMEPREFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[INITIALS] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CALLINGNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FIRSTNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MIDDLENAMES] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAMEINFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTNAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAMESUFFIX] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FULLNAME] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSON_TBL] (
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[GENDER] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NATIONALITY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BIRTHDATE] [datetime] NULL ,
	[BIRTHTIME] [datetime] NULL ,
	[BIRTHCOUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BIRTHPLACE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DATEOFDEATH] [datetime] NULL ,
	[NAMETYPEPREF] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ADDRTYPEPREF] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PHONETYPEPREF] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAILTYPEPREF] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_PERSPHONE_EFFDT] (
	[PERSID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PHONETYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AREACODE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCALCODE] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EXTENTIONCHARS] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_POSTAL_REF_TBL] (
	[COUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[POSTAL] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[POSTAL_RANGE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[POSTAL_BRKPNT_FROM] [int] NULL ,
	[POSTAL_BRKPNT_UNTIL] [int] NULL ,
	[POSTAL_STREET] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[POSTAL_CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[POSTAL_STATE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_ROOM_TBL] (
	[BLDGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ROOMID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FLOOR] [int] NULL ,
	[WING] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ROOM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_SECTION_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SECTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_STATE_TBL] (
	[COUNTRY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[STATE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_SUBDEPT_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DEPTID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SUBDEPTID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AC_SUBSECTION_TBL] (
	[ORGID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SECTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SUBSECTIONID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC2_TEL_TOESTEL_TBL] (
	[TOESTEL_ID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SHORTDESCR] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC2_UTP_OUTLET_TBL] (
	[LOK_ID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[KAMER_ID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OUTLET_ID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OUTLET_TYPE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TELEFOONNR] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TOESTEL_ID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PERS_ID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJECT_TBL] (
	[PROJECTID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PERSID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJPLAN_TBL] (
	[PROJECTID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PROJECTPLANID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PERSID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJTASKPERS_TBL] (
	[PROJECTID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PROJECTPLANID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PROJECTTASKID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PERSID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STARTDT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ENDDT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HOURS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[X_AC_PROJTASK_TBL] (
	[PROJECTID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PROJECTPLANID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PROJECTTASKID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRSHORT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCRLONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SECTIONID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HOURS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ACACCESSDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACACCESSDEFN] PRIMARY KEY  CLUSTERED 
	(
		[ACCESSID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACACTIONDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACACTIONDEFN] PRIMARY KEY  CLUSTERED 
	(
		[ACTIONID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACACTIONITEMS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACACTIONITEMS] PRIMARY KEY  CLUSTERED 
	(
		[ACTIONID],
		[SEQUENCENR]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACCONDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_CONNECTION] PRIMARY KEY  CLUSTERED 
	(
		[CONID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACCONSQLDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACCONSQLDEFN] PRIMARY KEY  CLUSTERED 
	(
		[CONID],
		[SQLACTIONID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACFIELDDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK__ACFIELDDEFN] PRIMARY KEY  CLUSTERED 
	(
		[FIELDNAME]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACFIELDDEFN_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACFIELDDEFN_LNG] PRIMARY KEY  CLUSTERED 
	(
		[FIELDNAME],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACOPRDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK__ACOPRDEFN] PRIMARY KEY  CLUSTERED 
	(
		[OPRID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACRECDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK__ACRECDEFN] PRIMARY KEY  CLUSTERED 
	(
		[RECNAME]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACRECDEFN_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK__ACRECDEFN_LNG] PRIMARY KEY  CLUSTERED 
	(
		[RECNAME],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACRECFIELD] WITH NOCHECK ADD 
	CONSTRAINT [PK__ACRECFIELD] PRIMARY KEY  CLUSTERED 
	(
		[RECNAME],
		[FIELDNAME]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACREFVALUE] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACREFVALUE] PRIMARY KEY  CLUSTERED 
	(
		[FIELDNAME],
		[FIELDVALUE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACREFVALUE_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACREFVALUE_LNG] PRIMARY KEY  CLUSTERED 
	(
		[FIELDVALUE],
		[FIELDNAME],
		[EFFDT],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACSCHEDULE] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACSCHEDULE] PRIMARY KEY  CLUSTERED 
	(
		[SCHEDID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_BUILDING_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_BUILDING_TBL] PRIMARY KEY  CLUSTERED 
	(
		[BLDGID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_COUNTRY_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_COUNTRY_LNG] PRIMARY KEY  CLUSTERED 
	(
		[COUNTRY],
		[EFFDT],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_COUNTRY_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_COUNTRY_TBL] PRIMARY KEY  CLUSTERED 
	(
		[COUNTRY],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_DEPARTMENT_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK__AC_DEPARTMENT_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[DEPTID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_EMPLOYMENT_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_EMPLOYMENT_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[PERSID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_EXTERNALPERSID] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_PERSEXTID] PRIMARY KEY  CLUSTERED 
	(
		[PERSID],
		[EXTDATATYPE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_FUNCTION_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_FUNCTION_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[FUNCTIONID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_LANGUAGE_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACLANGUAGE] PRIMARY KEY  CLUSTERED 
	(
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_LOCATION_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_LOCATION_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[LOCID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NAMEINFIX_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NAMEINFIX_LNG] PRIMARY KEY  CLUSTERED 
	(
		[NAMEINFIX],
		[EFFDT],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NAMEINFIX_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NAME_INFIX_TBL] PRIMARY KEY  CLUSTERED 
	(
		[NAMEINFIX],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NAMEPREFIX_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NAMEPREFIX_LNG] PRIMARY KEY  CLUSTERED 
	(
		[NAMEPREFIX],
		[EFFDT],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NAMEPREFIX_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NAMEPREFIX] PRIMARY KEY  CLUSTERED 
	(
		[NAMEPREFIX],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NAMESUFFIX_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NAMESUFFIX_LNG] PRIMARY KEY  CLUSTERED 
	(
		[NAMESUFFIX],
		[EFFDT],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NAMESUFFIX_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NAMESUFFIX_TBL] PRIMARY KEY  CLUSTERED 
	(
		[NAMESUFFIX],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NATIONALITY_LNG] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NATIONALITY_LNG] PRIMARY KEY  CLUSTERED 
	(
		[NATIONALITY],
		[EFFDT],
		[LANGUAGECD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_NATIONALITY_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_NATIONALITY] PRIMARY KEY  CLUSTERED 
	(
		[NATIONALITY],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_ORGANIZATION_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_ORGANIZATION_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_ORG_TYPE] WITH NOCHECK ADD 
	CONSTRAINT [PK__AC_ORG_TYPE] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[ORGTYPE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_PERSADDR_EFFDT] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_PERSADDR_EFFDT] PRIMARY KEY  CLUSTERED 
	(
		[PERSID],
		[ADDRTYPE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_PERSEMAIL_EFFDT] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_PERSEMAIL_EFFDT] PRIMARY KEY  CLUSTERED 
	(
		[PERSID],
		[EMAILTYPE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_PERSNAME_EFFDT] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_PERSNAME_EFFDT] PRIMARY KEY  CLUSTERED 
	(
		[PERSID],
		[NAMETYPE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_PERSON_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_PERSON_TBL] PRIMARY KEY  CLUSTERED 
	(
		[PERSID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_PERSPHONE_EFFDT] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_PERSPHONE_EFFDT] PRIMARY KEY  CLUSTERED 
	(
		[PERSID],
		[PHONETYPE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_POSTAL_REF_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_POSTAL_TBL] PRIMARY KEY  CLUSTERED 
	(
		[COUNTRY],
		[POSTAL],
		[POSTAL_RANGE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_ROOM_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_ROOM_TBL] PRIMARY KEY  CLUSTERED 
	(
		[BLDGID],
		[ROOMID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_SECTION_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK__AC_SECTION_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[SECTIONID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_STATE_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_STATE_TBL] PRIMARY KEY  CLUSTERED 
	(
		[COUNTRY],
		[STATE],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_SUBDEPT_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_SUBDEPT_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[DEPTID],
		[SUBDEPTID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AC_SUBSECTION_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_SUBSECTION_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[SECTIONID],
		[SUBSECTIONID],
		[EFFDT]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER OFF 
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

SET QUOTED_IDENTIFIER OFF 
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


/****** Object:  Stored Procedure dbo.NEWORGID    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[NEWORGID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NEWORGID]
GO

/****** Object:  Stored Procedure dbo.NEWPERSID    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[NEWPERSID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NEWPERSID]
GO

/****** Object:  View dbo.AC_PERSON_VW    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_PERSON_VW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[AC_PERSON_VW]
GO

/****** Object:  Table [dbo].[AB_Base]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AB_Base]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_Base]
GO

/****** Object:  Table [dbo].[AB_NAW]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AB_NAW]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_NAW]
GO

/****** Object:  Table [dbo].[AB_SORT]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AB_SORT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_SORT]
GO

/****** Object:  Table [dbo].[AB_SortKenmerk]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AB_SortKenmerk]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_SortKenmerk]
GO

/****** Object:  Table [dbo].[ACACCESSDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACACCESSDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACACCESSDEFN]
GO

/****** Object:  Table [dbo].[ACACTIONDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACACTIONDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACACTIONDEFN]
GO

/****** Object:  Table [dbo].[ACACTIONITEMS]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACACTIONITEMS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACACTIONITEMS]
GO

/****** Object:  Table [dbo].[ACCONDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACCONDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACCONDEFN]
GO

/****** Object:  Table [dbo].[ACCONFIGBASE]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACCONFIGBASE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACCONFIGBASE]
GO

/****** Object:  Table [dbo].[ACCONSQLDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACCONSQLDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACCONSQLDEFN]
GO

/****** Object:  Table [dbo].[ACFIELDDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACFIELDDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDDEFN]
GO

/****** Object:  Table [dbo].[ACFIELDDEFN_LNG]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACFIELDDEFN_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDDEFN_LNG]
GO

/****** Object:  Table [dbo].[ACOPRDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACOPRDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACOPRDEFN]
GO

/****** Object:  Table [dbo].[ACRECDEFN]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACRECDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACRECDEFN]
GO

/****** Object:  Table [dbo].[ACRECDEFN_LNG]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACRECDEFN_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACRECDEFN_LNG]
GO

/****** Object:  Table [dbo].[ACRECFIELD]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACRECFIELD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACRECFIELD]
GO

/****** Object:  Table [dbo].[ACREFVALUE]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACREFVALUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACREFVALUE]
GO

/****** Object:  Table [dbo].[ACREFVALUE_LNG]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACREFVALUE_LNG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACREFVALUE_LNG]
GO

/****** Object:  Table [dbo].[ACSCHEDULE]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACSCHEDULE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACSCHEDULE]
GO

/****** Object:  Table [dbo].[ACTMP_IMPORTPERS]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ACTMP_IMPORTPERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTMP_IMPORTPERS]
GO

/****** Object:  Table [dbo].[AC_BUILDING_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_BUILDING_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_BUILDING_TBL]
GO

/****** Object:  Table [dbo].[AC_DEPARTMENT_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_DEPARTMENT_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_DEPARTMENT_TBL]
GO

/****** Object:  Table [dbo].[AC_FUNCTION_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_FUNCTION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_FUNCTION_TBL]
GO

/****** Object:  Table [dbo].[AC_LOCATION_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_LOCATION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_LOCATION_TBL]
GO

/****** Object:  Table [dbo].[AC_ORG_TYPE]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_ORG_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_ORG_TYPE]
GO

/****** Object:  Table [dbo].[AC_POSTAL_REF_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_POSTAL_REF_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_POSTAL_REF_TBL]
GO

/****** Object:  Table [dbo].[AC_ROOM_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_ROOM_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_ROOM_TBL]
GO

/****** Object:  Table [dbo].[AC_SECTION_TBL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[AC_SECTION_TBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AC_SECTION_TBL]
GO

/****** Object:  Table [dbo].[TD_HARDWARE]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[TD_HARDWARE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TD_HARDWARE]
GO

/****** Object:  Table [dbo].[TD_PERSONEEL]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[TD_PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TD_PERSONEEL]
GO

/****** Object:  Table [dbo].[~Locaties]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[~Locaties]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[~Locaties]
GO

/****** Object:  Table [dbo].[~Organisaties]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[~Organisaties]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[~Organisaties]
GO

/****** Object:  Table [dbo].[~Organisaties1]    Script Date: 11/14/03 10:59:39 PM ******/
if exists (select * from sysobjects where id = object_id(N'[dbo].[~Organisaties1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[~Organisaties1]
GO

/****** Object:  Table [dbo].[AB_Base]    Script Date: 11/14/03 10:59:45 PM ******/
CREATE TABLE [dbo].[AB_Base] (
	[stamnr] [nvarchar] (50) NULL ,
	[dv_datum_einde] [nvarchar] (50) NULL ,
	[datum] [nvarchar] (50) NULL ,
	[burgstaat] [nvarchar] (1) NULL ,
	[geslacht] [nvarchar] (5) NULL ,
	[roepnaam] [nvarchar] (50) NULL ,
	[naam] [nvarchar] (50) NULL ,
	[gebdatum] [smalldatetime] NULL ,
	[adres] [nvarchar] (50) NULL ,
	[huisnr] [nvarchar] (50) NULL ,
	[toevhuisnr] [nvarchar] (50) NULL ,
	[postcode] [nvarchar] (50) NULL ,
	[plaats] [nvarchar] (50) NULL ,
	[TelnrPrive] [nvarchar] (50) NULL ,
	[TelnrWerk] [nvarchar] (50) NULL ,
	[afkorting] [nvarchar] (50) NULL ,
	[functiecode] [nvarchar] (50) NULL ,
	[functie] [nvarchar] (50) NULL ,
	[SdvNr] [nvarchar] (50) NULL ,
	[cso] [nvarchar] (50) NULL ,
	[kpl] [nvarchar] (50) NULL ,
	[factor] [nvarchar] (50) NULL ,
	[locatie] [nvarchar] (50) NULL ,
	[sortkenm] [nvarchar] (50) NULL ,
	[OECODE_1] [nvarchar] (50) NULL ,
	[LOCCODE_1] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[AB_NAW]    Script Date: 11/14/03 10:59:45 PM ******/
CREATE TABLE [dbo].[AB_NAW] (
	[stamnr] [nvarchar] (50) NULL ,
	[gebdatum] [smalldatetime] NULL ,
	[EersteVoornaam] [nvarchar] (50) NULL ,
	[OverigeVoornamen] [nvarchar] (50) NULL ,
	[relatiecode] [nvarchar] (50) NULL ,
	[voorl] [nvarchar] (50) NULL ,
	[vvp] [nvarchar] (50) NULL ,
	[NaamPartner] [nvarchar] (50) NULL ,
	[vv] [nvarchar] (50) NULL ,
	[eigennaam] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[AB_SORT]    Script Date: 11/14/03 10:59:45 PM ******/
CREATE TABLE [dbo].[AB_SORT] (
	[sortkenmerk] [nvarchar] (50) NOT NULL ,
	[afdeling] [nvarchar] (50) NULL ,
	[locatie] [nvarchar] (50) NULL ,
	[unit] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[AB_SortKenmerk]    Script Date: 11/14/03 10:59:46 PM ******/
CREATE TABLE [dbo].[AB_SortKenmerk] (
	[sortkenmerk] [nvarchar] (50) NOT NULL ,
	[afdeling] [nvarchar] (50) NULL ,
	[locatie] [nvarchar] (50) NULL ,
	[unit] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACACCESSDEFN]    Script Date: 11/14/03 10:59:46 PM ******/
CREATE TABLE [dbo].[ACACCESSDEFN] (
	[ACCESSID] [varchar] (8) NOT NULL ,
	[ACCESSENCCD] [varchar] (6) NULL ,
	[ACCESSSECPW] [varchar] (20) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACACTIONDEFN]    Script Date: 11/14/03 10:59:46 PM ******/
CREATE TABLE [dbo].[ACACTIONDEFN] (
	[ACTIONID] [varchar] (12) NOT NULL ,
	[SCHEDID] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRLONG] [varchar] (256) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACACTIONITEMS]    Script Date: 11/14/03 10:59:46 PM ******/
CREATE TABLE [dbo].[ACACTIONITEMS] (
	[ACTIONID] [varchar] (12) NOT NULL ,
	[SEQUENCENR] [varchar] (6) NOT NULL ,
	[CONID] [varchar] (12) NULL ,
	[SQLACTIONID] [varchar] (12) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACCONDEFN]    Script Date: 11/14/03 10:59:46 PM ******/
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

/****** Object:  Table [dbo].[ACCONFIGBASE]    Script Date: 11/14/03 10:59:46 PM ******/
CREATE TABLE [dbo].[ACCONFIGBASE] (
	[PERSID_LAST] [varchar] (12) NULL ,
	[LANGUAGE_BASE] [varchar] (6) NULL ,
	[CURRENCY_BASE] [varchar] (6) NULL ,
	[ORGID_LAST] [varchar] (12) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACCONSQLDEFN]    Script Date: 11/14/03 10:59:46 PM ******/
CREATE TABLE [dbo].[ACCONSQLDEFN] (
	[CONID] [varchar] (12) NOT NULL ,
	[SQLACTIONID] [varchar] (12) NOT NULL ,
	[SQLSTTMNT] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACFIELDDEFN]    Script Date: 11/14/03 10:59:47 PM ******/
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

/****** Object:  Table [dbo].[ACFIELDDEFN_LNG]    Script Date: 11/14/03 10:59:47 PM ******/
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

/****** Object:  Table [dbo].[ACOPRDEFN]    Script Date: 11/14/03 10:59:47 PM ******/
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

/****** Object:  Table [dbo].[ACRECDEFN]    Script Date: 11/14/03 10:59:47 PM ******/
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

/****** Object:  Table [dbo].[ACRECDEFN_LNG]    Script Date: 11/14/03 10:59:47 PM ******/
CREATE TABLE [dbo].[ACRECDEFN_LNG] (
	[RECNAME] [varchar] (17) NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCR] [varchar] (64) NULL ,
	[DESCRTEXT] [text] NULL ,
	[LASTUPDDTTM] [datetime] NULL ,
	[LASTUPDOPRID] [varchar] (8) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACRECFIELD]    Script Date: 11/14/03 10:59:47 PM ******/
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

/****** Object:  Table [dbo].[ACREFVALUE]    Script Date: 11/14/03 10:59:48 PM ******/
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

/****** Object:  Table [dbo].[ACREFVALUE_LNG]    Script Date: 11/14/03 10:59:48 PM ******/
CREATE TABLE [dbo].[ACREFVALUE_LNG] (
	[FIELDNAME] [varchar] (20) NOT NULL ,
	[FIELDVALUE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[LANGUAGECD] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (64) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACSCHEDULE]    Script Date: 11/14/03 10:59:48 PM ******/
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

/****** Object:  Table [dbo].[ACTMP_IMPORTPERS]    Script Date: 11/14/03 10:59:48 PM ******/
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
	[PREFTUSSENV] [varchar] (50) NULL ,
	[PREFACHTERN] [varchar] (50) NULL ,
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

/****** Object:  Table [dbo].[AC_BUILDING_TBL]    Script Date: 11/14/03 10:59:48 PM ******/
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

/****** Object:  Table [dbo].[AC_DEPARTMENT_TBL]    Script Date: 11/14/03 10:59:48 PM ******/
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

/****** Object:  Table [dbo].[AC_FUNCTION_TBL]    Script Date: 11/14/03 10:59:49 PM ******/
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

/****** Object:  Table [dbo].[AC_LOCATION_TBL]    Script Date: 11/14/03 10:59:49 PM ******/
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

/****** Object:  Table [dbo].[AC_ORG_TYPE]    Script Date: 11/14/03 10:59:49 PM ******/
CREATE TABLE [dbo].[AC_ORG_TYPE] (
	[ORGID] [varchar] (12) NOT NULL ,
	[ORGTYPE] [varchar] (6) NOT NULL ,
	[EFFDT] [datetime] NOT NULL ,
	[EFFSTATUS] [varchar] (6) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[AC_POSTAL_REF_TBL]    Script Date: 11/14/03 10:59:49 PM ******/
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

/****** Object:  Table [dbo].[AC_ROOM_TBL]    Script Date: 11/14/03 10:59:49 PM ******/
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

/****** Object:  Table [dbo].[AC_SECTION_TBL]    Script Date: 11/14/03 10:59:49 PM ******/
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

/****** Object:  Table [dbo].[TD_HARDWARE]    Script Date: 11/14/03 10:59:50 PM ******/
CREATE TABLE [dbo].[TD_HARDWARE] (
	[objectid] [nvarchar] (30) NOT NULL ,
	[configuratie] [nvarchar] (30) NULL ,
	[budgethouder] [nvarchar] (30) NULL ,
	[soort] [nvarchar] (30) NULL ,
	[merk] [nvarchar] (30) NULL ,
	[type] [nvarchar] (30) NULL ,
	[specificatie] [nvarchar] (30) NULL ,
	[installatie] [nvarchar] (30) NULL ,
	[serienummer] [nvarchar] (30) NULL ,
	[leverancier] [nvarchar] (60) NULL ,
	[aanschaf] [datetime] NULL ,
	[garantietot] [datetime] NULL ,
	[verzekerdtot] [datetime] NULL ,
	[aankoopbedrag] [money] NULL ,
	[restwaarde] [money] NULL ,
	[afschrijvenin] [int] NULL ,
	[status] [nvarchar] (30) NULL ,
	[ipadres] [nvarchar] (20) NULL ,
	[hostnaam] [nvarchar] (20) NULL ,
	[millenniumproof] [nvarchar] (30) NULL ,
	[processor] [nvarchar] (30) NULL ,
	[kloksnelheid] [nvarchar] (30) NULL ,
	[hardeschijf] [nvarchar] (30) NULL ,
	[partities] [int] NULL ,
	[interngeheugen] [nvarchar] (30) NULL ,
	[soortgeheugen] [nvarchar] (30) NULL ,
	[geheugenbanken] [int] NULL ,
	[ingebruik] [int] NULL ,
	[diversen] [text] NULL ,
	[merk1] [nvarchar] (30) NULL ,
	[type1] [nvarchar] (30) NULL ,
	[serienummer1] [nvarchar] (30) NULL ,
	[merk2] [nvarchar] (30) NULL ,
	[type2] [nvarchar] (30) NULL ,
	[serienummer2] [nvarchar] (30) NULL ,
	[merk3] [nvarchar] (30) NULL ,
	[type3] [nvarchar] (30) NULL ,
	[merk4] [nvarchar] (30) NULL ,
	[type4] [nvarchar] (30) NULL ,
	[merk5] [nvarchar] (30) NULL ,
	[type5] [nvarchar] (30) NULL ,
	[adres] [nvarchar] (30) NULL ,
	[merk6] [nvarchar] (30) NULL ,
	[type6] [nvarchar] (30) NULL ,
	[baudrate] [nvarchar] (30) NULL ,
	[type7] [nvarchar] (30) NULL ,
	[merk7] [nvarchar] (30) NULL ,
	[snelheid] [nvarchar] (30) NULL ,
	[aantekeningen] [text] NULL ,
	[tekst1] [nvarchar] (30) NULL ,
	[tekst2] [nvarchar] (30) NULL ,
	[tekst3] [nvarchar] (30) NULL ,
	[tekst4] [nvarchar] (30) NULL ,
	[tekst5] [nvarchar] (30) NULL ,
	[opzoeklijst1] [nvarchar] (30) NULL ,
	[opzoeklijst2] [nvarchar] (30) NULL ,
	[opzoeklijst3] [nvarchar] (30) NULL ,
	[getal1] [float] NULL ,
	[getal2] [float] NULL ,
	[datum1] [datetime] NULL ,
	[datum2] [datetime] NULL ,
	[logisch1] [bit] NULL ,
	[logisch2] [bit] NULL ,
	[logisch3] [bit] NULL ,
	[logisch4] [bit] NULL ,
	[logisch5] [bit] NULL ,
	[aantekeningen1] [text] NULL ,
	[aantekeningen2] [text] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TD_PERSONEEL]    Script Date: 11/14/03 10:59:50 PM ******/
CREATE TABLE [dbo].[TD_PERSONEEL] (
	[personeeli] [nvarchar] (50) NOT NULL ,
	[voornamen] [nvarchar] (30) NOT NULL ,
	[achternaam] [nvarchar] (30) NOT NULL ,
	[voorletters] [nvarchar] (10) NOT NULL ,
	[tussenvoegsels] [nvarchar] (10) NULL ,
	[vestiging] [nvarchar] (60) NULL ,
	[locatie] [nvarchar] (30) NOT NULL ,
	[afdeling] [nvarchar] (30) NOT NULL ,
	[budgethouder] [nvarchar] (30) NOT NULL ,
	[titel] [nvarchar] (10) NULL ,
	[geslacht] [int] NULL ,
	[functie] [nvarchar] (30) NULL ,
	[personeelsnr] [nvarchar] (20) NULL ,
	[mobiel] [nvarchar] (25) NULL ,
	[telefoon] [nvarchar] (25) NULL ,
	[fax] [nvarchar] (25) NULL ,
	[email] [nvarchar] (50) NULL ,
	[netwerk] [nvarchar] (30) NULL ,
	[mainframe] [nvarchar] (30) NULL ,
	[diversen] [ntext] NULL ,
	[straat] [nvarchar] (50) NULL ,
	[nr] [nvarchar] (6) NULL ,
	[postcode] [nvarchar] (15) NULL ,
	[plaats] [nvarchar] (30) NULL ,
	[land] [nvarchar] (30) NULL ,
	[email2] [nvarchar] (50) NULL ,
	[geboren] [nvarchar] (10) NULL ,
	[telefoon1] [nvarchar] (25) NULL ,
	[telefoon2] [nvarchar] (25) NULL ,
	[mobiel2] [nvarchar] (25) NULL ,
	[fax2] [nvarchar] (25) NULL ,
	[aantekeningen] [ntext] NULL ,
	[tekst1] [nvarchar] (30) NULL ,
	[tekst2] [nvarchar] (30) NULL ,
	[tekst3] [nvarchar] (30) NULL ,
	[tekst4] [nvarchar] (30) NULL ,
	[tekst5] [nvarchar] (30) NULL ,
	[opzoeklijst1] [nvarchar] (30) NULL ,
	[opzoeklijst2] [nvarchar] (30) NULL ,
	[opzoeklijst3] [nvarchar] (30) NULL ,
	[getal1] [int] NULL ,
	[getal2] [int] NULL ,
	[datum1] [nvarchar] (10) NULL ,
	[datum2] [nvarchar] (10) NULL ,
	[logisch1] [int] NULL ,
	[logisch2] [int] NULL ,
	[logisch3] [int] NULL ,
	[logisch4] [int] NULL ,
	[logisch5] [int] NULL ,
	[aantekeningen1] [ntext] NULL ,
	[aantekeningen2] [ntext] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[~Locaties]    Script Date: 11/14/03 10:59:50 PM ******/
CREATE TABLE [dbo].[~Locaties] (
	[Id] [float] NULL ,
	[omschrijving] [nvarchar] (255) NULL ,
	[Locatie Nummer] [float] NULL ,
	[Omschrijving1] [nvarchar] (255) NULL ,
	[Land] [nvarchar] (255) NULL ,
	[Straatnaam] [nvarchar] (255) NULL ,
	[Nummer] [float] NULL ,
	[Toevoeging] [float] NULL ,
	[Plaats] [nvarchar] (255) NULL ,
	[Postcode] [nvarchar] (255) NULL ,
	[e-mail] [nvarchar] (255) NULL ,
	[soort telefoonnr] [nvarchar] (255) NULL ,
	[telefoonnr] [nvarchar] (255) NULL ,
	[soort telefoonnr2] [nvarchar] (255) NULL ,
	[telefoonnr2] [nvarchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[~Organisaties]    Script Date: 11/14/03 10:59:50 PM ******/
CREATE TABLE [dbo].[~Organisaties] (
	[ID externe org] [float] NULL ,
	[ingangs_datum] [smalldatetime] NULL ,
	[status] [nvarchar] (255) NULL ,
	[omschrijving] [nvarchar] (255) NULL ,
	[lange_omschrijving] [nvarchar] (255) NULL ,
	[korte_omschrijving] [nvarchar] (255) NULL ,
	[soort_org] [nvarchar] (255) NULL ,
	[eigendomsinformatie] [nvarchar] (255) NULL ,
	[Veld9] [nvarchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[~Organisaties1]    Script Date: 11/14/03 10:59:51 PM ******/
CREATE TABLE [dbo].[~Organisaties1] (
	[EXT_ORG_ID] [char] (11) NOT NULL ,
	[EFFDT] [PSDATE] NOT NULL ,
	[EFF_STATUS] [char] (1) NOT NULL ,
	[OTH_NAME_SORT_SRCH] [char] (50) NOT NULL ,
	[EXT_ORG_TYPE] [char] (4) NOT NULL ,
	[SCHOOL_CODE] [char] (10) NOT NULL ,
	[SCHOOL_TYPE] [char] (3) NOT NULL ,
	[FICE_CD] [char] (6) NOT NULL ,
	[ATP_CD] [char] (6) NOT NULL ,
	[ADDRESS1] [char] (35) NOT NULL ,
	[ADDRESS2] [char] (35) NOT NULL ,
	[ADDRESS3] [char] (35) NOT NULL ,
	[ADDRESS4] [char] (35) NOT NULL ,
	[NUM1] [char] (6) NOT NULL ,
	[NUM2] [char] (4) NOT NULL ,
	[HOUSE_TYPE] [char] (2) NOT NULL ,
	[GEO_CODE] [char] (11) NOT NULL ,
	[CITY] [char] (30) NOT NULL ,
	[IN_CITY_LIMIT] [char] (1) NOT NULL ,
	[COUNTY] [char] (30) NOT NULL ,
	[STATE] [char] (6) NOT NULL ,
	[POSTAL] [char] (12) NOT NULL ,
	[COUNTRY] [char] (3) NOT NULL ,
	[DESCR] [char] (30) NOT NULL ,
	[DESCR50] [char] (50) NOT NULL ,
	[DESCRSHORT] [char] (10) NOT NULL ,
	[ORG_CONTACT] [smallint] NOT NULL ,
	[ORG_LOCATION] [smallint] NOT NULL ,
	[ORG_DEPARTMENT] [smallint] NOT NULL ,
	[OFFERS_COURSES] [char] (1) NOT NULL ,
	[PROPRIETORSHIP] [char] (4) NOT NULL ,
	[ACT_CD] [char] (6) NOT NULL ,
	[IPEDS_CD] [char] (6) NOT NULL ,
	[SCHOOL_DISTRICT] [char] (50) NOT NULL ,
	[ACCREDITED] [char] (1) NOT NULL ,
	[TRANSCRIPT_XLATE] [char] (1) NOT NULL ,
	[UNT_TYPE] [char] (3) NOT NULL ,
	[EXT_TERM_TYPE] [char] (4) NOT NULL ,
	[EXT_CAREER] [char] (4) NOT NULL ,
	[SHARED_CATALOG] [char] (1) NOT NULL ,
	[CATALOG_ORG] [char] (11) NOT NULL ,
	[CHG_OTHER] [char] (1) NOT NULL ,
	[SETID] [char] (5) NOT NULL ,
	[VENDOR_ID] [char] (10) NOT NULL ,
	[TAXPAYER_ID_NO] [char] (9) NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AB_SortKenmerk] WITH NOCHECK ADD 
	CONSTRAINT [PK_AB_SortKenmerk] PRIMARY KEY  CLUSTERED 
	(
		[sortkenmerk]
	)  ON [PRIMARY] 
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

ALTER TABLE [dbo].[AC_DEPARTMENT_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK__AC_DEPARTMENT_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[DEPTID],
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

ALTER TABLE [dbo].[AC_LOCATION_TBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_AC_LOCATION_TBL] PRIMARY KEY  CLUSTERED 
	(
		[ORGID],
		[LOCID],
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

ALTER TABLE [dbo].[TD_PERSONEEL] WITH NOCHECK ADD 
	CONSTRAINT [PK_PersoneelTopdesk] PRIMARY KEY  CLUSTERED 
	(
		[personeeli]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO

/****** Object:  View dbo.AC_PERSON_VW    Script Date: 11/14/03 10:59:51 PM ******/
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

GO

SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO

SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO

/****** Object:  Stored Procedure dbo.NEWORGID    Script Date: 11/14/03 10:59:51 PM ******/
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

SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO

SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO

/****** Object:  Stored Procedure dbo.NEWPERSID    Script Date: 11/14/03 10:59:51 PM ******/
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

SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO


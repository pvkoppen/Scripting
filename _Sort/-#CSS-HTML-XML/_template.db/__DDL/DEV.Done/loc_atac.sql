if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACFIELDVALUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDVALUE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACOPRDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACOPRDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EXT_PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EXT_PERSONEEL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EXT_PERS_EDU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EXT_PERS_EDU]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FUNCTIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FUNCTIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOKATIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LOKATIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERSONEEL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERS_LOK]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERS_LOK]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UNITS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UNITS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[_SEXE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[_SEXE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[_SORTKENMERK]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[_SORTKENMERK]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[_TUSSENVOEG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[_TUSSENVOEG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[_qEXPORT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[_qEXPORT]
GO

CREATE TABLE [dbo].[ACFIELDVALUE] (
	[FIELDNAME] [varchar] (12) NOT NULL ,
	[FIELDVALUE] [varchar] (6) NOT NULL ,
	[DESCRSHORT] [varchar] (12) NULL ,
	[DESCR] [varchar] (32) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACOPRDEFN] (
	[OPR_ID] [varchar] (6) NOT NULL ,
	[PERS_ID] [varchar] (3) NULL ,
	[RECHTEN] [int] NULL ,
	[WACHTWOORD] [varchar] (10) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXT_PERSONEEL] (
	[EXT_PERS_ID] [varchar] (12) NOT NULL ,
	[ACTIEDATUM] [datetime] NOT NULL ,
	[STATUS] [varchar] (1) NULL ,
	[VOORLETTERS] [varchar] (10) NULL ,
	[VOORNAAM] [varchar] (30) NULL ,
	[TUSSENVOEG] [varchar] (15) NULL ,
	[ACHTERNAAM] [varchar] (30) NULL ,
	[VOLLEDIGENAAM] [varchar] (60) NULL ,
	[FUNCTIE] [varchar] (60) NULL ,
	[SORTKENMERK] [varchar] (6) NULL ,
	[SEXE] [varchar] (1) NULL ,
	[PRIVETELNR] [varchar] (12) NULL ,
	[BIRTHDATE] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXT_PERS_EDU] (
	[STAMNR] [varchar] (12) NOT NULL ,
	[AANHEF] [varchar] (12) NULL ,
	[VOORNAAM] [varchar] (60) NULL ,
	[VOORLETTERS] [varchar] (12) NULL ,
	[VOORVOEGSEL] [varchar] (20) NULL ,
	[ACHTERNAAM] [varchar] (60) NULL ,
	[VOLLENAAM] [varchar] (100) NULL ,
	[FUNCTIE] [varchar] (100) NULL ,
	[SORTKENMERK] [varchar] (12) NULL ,
	[PRIVETELNR] [varchar] (20) NULL ,
	[GEBDATUM] [datetime] NULL ,
	[SEXE] [varchar] (1) NULL ,
	[NAAMPARTNER] [varchar] (60) NULL ,
	[VOORVOEGPARTNER] [varchar] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FUNCTIES] (
	[FUNCTIE_ID] [varchar] (6) NOT NULL ,
	[NAAM] [varchar] (60) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LOKATIES] (
	[LOKATIE_ID] [varchar] (4) NOT NULL ,
	[NAAM] [varchar] (60) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERSONEEL] (
	[PERS_ID] [varchar] (3) NOT NULL ,
	[EFFDT] [datetime] NULL ,
	[EFFSTATUS] [varchar] (6) NULL ,
	[EXT_PERS_ID] [varchar] (12) NULL ,
	[VOORLETTERS] [varchar] (10) NULL ,
	[VOORNAAM] [varchar] (30) NULL ,
	[TUSSENV] [varchar] (15) NULL ,
	[ACHTERNAAM] [varchar] (30) NULL ,
	[GEBDATUM] [datetime] NULL ,
	[SEXEID] [varchar] (1) NULL ,
	[UNIT_ID] [varchar] (3) NULL ,
	[FUNCTIE_ID] [varchar] (6) NULL ,
	[LOKATIE_ID] [varchar] (4) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERS_LOK] (
	[PERS_ID] [varchar] (3) NOT NULL ,
	[LOKATIE_ID] [varchar] (4) NOT NULL ,
	[KAMER] [varchar] (20) NULL ,
	[TELEFOONNR] [varchar] (11) NULL ,
	[AFWEZIG] [varchar] (255) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UNITS] (
	[UNIT_ID] [varchar] (3) NOT NULL ,
	[NAAM] [varchar] (60) NULL ,
	[LASTUPDOPR_ID] [varchar] (8) NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_SEXE] (
	[SEXE] [varchar] (6) NOT NULL ,
	[AANSPREEK] [varchar] (12) NULL ,
	[AANHEF] [varchar] (12) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_SORTKENMERK] (
	[SORTKENMERK] [varchar] (10) NOT NULL ,
	[UNIT] [varchar] (10) NULL ,
	[LOCATIE] [varchar] (10) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_TUSSENVOEG] (
	[TUSSENVOEG] [varchar] (20) NOT NULL ,
	[VERTAAL] [varchar] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_qEXPORT] (
	[PERS_ID] [nvarchar] (3) NOT NULL ,
	[AANHEF] [nvarchar] (12) NULL ,
	[SEXE] [nvarchar] (1) NULL ,
	[VOORLETTER] [nvarchar] (10) NULL ,
	[ROEPNAAM] [nvarchar] (30) NULL ,
	[VOORVOEG] [nvarchar] (255) NOT NULL ,
	[ACHTERNAAM] [nvarchar] (60) NULL ,
	[AFDELING] [nvarchar] (10) NULL ,
	[FUNCTIE] [nvarchar] (60) NULL ,
	[OBJECT] [nvarchar] (10) NULL ,
	[TELNR] [nvarchar] (11) NULL ,
	[EMAIL] [nvarchar] (19) NOT NULL ,
	[EDUKAATNR] [nvarchar] (12) NOT NULL 
) ON [PRIMARY]
GO


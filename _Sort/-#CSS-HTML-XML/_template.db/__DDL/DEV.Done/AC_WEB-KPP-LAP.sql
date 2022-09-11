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
	[FIELDNAME] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FIELDVALUE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACOPRDEFN] (
	[OPR_ID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PERS_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RECHTEN] [int] NULL ,
	[WACHTWOORD] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXT_PERSONEEL] (
	[EXT_PERS_ID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ACTIEDATUM] [datetime] NOT NULL ,
	[STATUS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TUSSENVOEG] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLEDIGENAAM] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIE] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SORTKENMERK] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SEXE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVETELNR] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BIRTHDATE] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXT_PERS_EDU] (
	[STAMNR] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AANHEF] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEGSEL] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLENAAM] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIE] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SORTKENMERK] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PRIVETELNR] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GEBDATUM] [datetime] NULL ,
	[SEXE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAAMPARTNER] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEGPARTNER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FUNCTIES] (
	[FUNCTIE_ID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NAAM] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LOKATIES] (
	[LOKATIE_ID] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NAAM] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERSONEEL] (
	[PERS_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EFFDT] [datetime] NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EXT_PERS_ID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TUSSENV] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GEBDATUM] [datetime] NULL ,
	[SEXEID] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UNIT_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIE_ID] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOKATIE_ID] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERS_LOK] (
	[PERS_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LOKATIE_ID] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[KAMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TELEFOONNR] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AFWEZIG] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UNITS] (
	[UNIT_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NAAM] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_SEXE] (
	[SEXE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AANSPREEK] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AANHEF] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_SORTKENMERK] (
	[SORTKENMERK] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[UNIT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCATIE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_TUSSENVOEG] (
	[TUSSENVOEG] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[VERTAAL] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_qEXPORT] (
	[PERS_ID] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AANHEF] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SEXE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ROEPNAAM] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ACHTERNAAM] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AFDELING] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FUNCTIE] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OBJECT] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TELNR] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAIL] [nvarchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EDUKAATNR] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ACFIELDVALUE] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACFIELDVALUE] PRIMARY KEY  CLUSTERED 
	(
		[FIELDNAME],
		[FIELDVALUE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACOPRDEFN] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACOPRDEFN] PRIMARY KEY  CLUSTERED 
	(
		[OPR_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EXT_PERSONEEL] WITH NOCHECK ADD 
	CONSTRAINT [PK_EXT_PERSONEEL] PRIMARY KEY  CLUSTERED 
	(
		[EXT_PERS_ID],
		[ACTIEDATUM]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EXT_PERS_EDU] WITH NOCHECK ADD 
	CONSTRAINT [PK_EXT_PERS_EDU] PRIMARY KEY  CLUSTERED 
	(
		[STAMNR]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FUNCTIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_FUNCTIES] PRIMARY KEY  CLUSTERED 
	(
		[FUNCTIE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOKATIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOKATIES] PRIMARY KEY  CLUSTERED 
	(
		[LOKATIE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERSONEEL] WITH NOCHECK ADD 
	CONSTRAINT [PK_PERSONEEL] PRIMARY KEY  CLUSTERED 
	(
		[PERS_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERS_LOK] WITH NOCHECK ADD 
	CONSTRAINT [PK_PERS_LOK] PRIMARY KEY  CLUSTERED 
	(
		[PERS_ID],
		[LOKATIE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[UNITS] WITH NOCHECK ADD 
	CONSTRAINT [PK_UNITS] PRIMARY KEY  CLUSTERED 
	(
		[UNIT_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[_SEXE] WITH NOCHECK ADD 
	CONSTRAINT [PK__SEXE] PRIMARY KEY  CLUSTERED 
	(
		[SEXE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[_SORTKENMERK] WITH NOCHECK ADD 
	CONSTRAINT [PK__SORTKENMERK] PRIMARY KEY  CLUSTERED 
	(
		[SORTKENMERK]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[_TUSSENVOEG] WITH NOCHECK ADD 
	CONSTRAINT [PK__TUSSENVOEG] PRIMARY KEY  CLUSTERED 
	(
		[TUSSENVOEG]
	)  ON [PRIMARY] 
GO


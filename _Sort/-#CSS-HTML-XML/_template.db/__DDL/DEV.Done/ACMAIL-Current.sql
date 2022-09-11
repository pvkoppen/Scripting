if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACFIELDVALUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDVALUE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACLOGIN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACLOGIN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HISTORIE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[HISTORIE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HISTORIEKOPIE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[HISTORIEKOPIE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOGGING]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LOGGING]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USERSKOPIE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USERSKOPIE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VERVANGLOCATIE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VERVANGLOCATIE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VERVANGTEKEN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VERVANGTEKEN]
GO

CREATE TABLE [dbo].[ACFIELDVALUE] (
	[FIELDNAME] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FIELDVALUE] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRSHORT] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DESCR] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACLOGIN] (
	[IDNUMMER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[WWRIGHT] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[USERRIGHT] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HISTORIE] (
	[IDNUMMER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BRON] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[INGANGSDATUM] [datetime] NULL ,
	[UITSCHRIJFDATUM] [datetime] NULL ,
	[AFKORTING] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAMOVERIG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEGSEL] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ALIASDATUM] [datetime] NULL ,
	[ALIAS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLEDIGENAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAILADRES] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UNIT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCATIE] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEP] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATUS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WACHTWOORD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACTIE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEPOMS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HISTORIEKOPIE] (
	[IDNUMMER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BRON] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[INGANGSDATUM] [datetime] NULL ,
	[UITSCHRIJFDATUM] [datetime] NULL ,
	[AFKORTING] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAMOVERIG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEGSEL] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ALIASDATUM] [datetime] NULL ,
	[ALIAS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLEDIGENAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAILADRES] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UNIT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCATIE] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEP] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATUS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WACHTWOORD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACTIE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEPOMS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LOGGING] (
	[SYSTEEM] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DATUMTIJD] [datetime] NULL ,
	[OMSCHRIJVING] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[USERS] (
	[IDNUMMER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BRON] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[INGANGSDATUM] [datetime] NULL ,
	[UITSCHRIJFDATUM] [datetime] NULL ,
	[AFKORTING] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAMOVERIG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEGSEL] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ALIASDATUM] [datetime] NULL ,
	[ALIAS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLEDIGENAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAILADRES] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UNIT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCATIE] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEP] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATUS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WACHTWOORD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACTIE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEPOMS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[USERSKOPIE] (
	[IDNUMMER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BRON] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[INGANGSDATUM] [datetime] NULL ,
	[UITSCHRIJFDATUM] [datetime] NULL ,
	[AFKORTING] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORNAAMOVERIG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORVOEGSEL] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACHTERNAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ALIASDATUM] [datetime] NULL ,
	[ALIAS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOLLEDIGENAAM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMAILADRES] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UNIT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCATIE] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEP] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATUS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WACHTWOORD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ACTIE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VOORLETTERS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STUDENTENGROEPOMS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[VERVANGLOCATIE] (
	[NAAMOUD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NAAMNIEUW] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[VERVANGTEKEN] (
	[ONJUIST] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[JUIST] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PERSONEEL_FUNCTIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PERSONEEL] DROP CONSTRAINT FK_PERSONEEL_FUNCTIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PERS_LOK_LOKATIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PERS_LOK] DROP CONSTRAINT FK_PERS_LOK_LOKATIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PERSONEEL_UNITS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PERSONEEL] DROP CONSTRAINT FK_PERSONEEL_UNITS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PERS_LOK_PERSONEEL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PERS_LOK] DROP CONSTRAINT FK_PERS_LOK_PERSONEEL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[_qEXPORT]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[_qEXPORT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERS_LOK]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERS_LOK]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERSONEEL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACFIELDVALUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACFIELDVALUE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACOPRDEFN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACOPRDEFN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EXT_PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EXT_PERSONEEL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FUNCTIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FUNCTIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOKATIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LOKATIES]
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

CREATE TABLE [dbo].[ACFIELDVALUE] (
	[FIELDNAME] [varchar] (12) COLLATE Latin1_General_BIN NOT NULL ,
	[FIELDVALUE] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL ,
	[DESCRSHORT] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[DESCR] [varchar] (32) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACOPRDEFN] (
	[OPR_ID] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL ,
	[PERS_ID] [varchar] (3) COLLATE Latin1_General_BIN NULL ,
	[RECHTEN] [int] NULL ,
	[WACHTWOORD] [varchar] (10) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXT_PERSONEEL] (
	[EXT_PERS_ID] [varchar] (12) COLLATE Latin1_General_BIN NOT NULL ,
	[ACTIEDATUM] [datetime] NOT NULL ,
	[STATUS] [varchar] (1) COLLATE Latin1_General_BIN NULL ,
	[VOORLETTERS] [varchar] (10) COLLATE Latin1_General_BIN NULL ,
	[VOORNAAM] [varchar] (30) COLLATE Latin1_General_BIN NULL ,
	[TUSSENVOEG] [varchar] (15) COLLATE Latin1_General_BIN NULL ,
	[ACHTERNAAM] [varchar] (30) COLLATE Latin1_General_BIN NULL ,
	[VOLLEDIGENAAM] [varchar] (60) COLLATE Latin1_General_BIN NULL ,
	[FUNCTIE] [varchar] (60) COLLATE Latin1_General_BIN NULL ,
	[SORTKENMERK] [varchar] (6) COLLATE Latin1_General_BIN NULL ,
	[SEXE] [varchar] (1) COLLATE Latin1_General_BIN NULL ,
	[PRIVETELNR] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[BIRTHDATE] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FUNCTIES] (
	[FUNCTIE_ID] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL ,
	[NAAM] [varchar] (60) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LOKATIES] (
	[LOKATIE_ID] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL ,
	[NAAM] [varchar] (60) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UNITS] (
	[UNIT_ID] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[NAAM] [varchar] (60) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_SEXE] (
	[SEXE] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL ,
	[AANSPREEK] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[AANHEF] [varchar] (12) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_SORTKENMERK] (
	[SORTKENMERK] [varchar] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[UNIT] [varchar] (10) COLLATE Latin1_General_BIN NULL ,
	[LOCATIE] [varchar] (10) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[_TUSSENVOEG] (
	[TUSSENVOEG] [varchar] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[VERTAAL] [varchar] (20) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERSONEEL] (
	[PERS_ID] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[EFFDT] [datetime] NULL ,
	[EFFSTATUS] [varchar] (6) COLLATE Latin1_General_BIN NULL ,
	[EXT_PERS_ID] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[VOORLETTERS] [varchar] (10) COLLATE Latin1_General_BIN NULL ,
	[VOORNAAM] [varchar] (30) COLLATE Latin1_General_BIN NULL ,
	[TUSSENV] [varchar] (15) COLLATE Latin1_General_BIN NULL ,
	[ACHTERNAAM] [varchar] (30) COLLATE Latin1_General_BIN NULL ,
	[GEBDATUM] [datetime] NULL ,
	[SEXEID] [varchar] (1) COLLATE Latin1_General_BIN NULL ,
	[UNIT_ID] [varchar] (3) COLLATE Latin1_General_BIN NULL ,
	[FUNCTIE_ID] [varchar] (6) COLLATE Latin1_General_BIN NULL ,
	[LOKATIE_ID] [varchar] (4) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERS_LOK] (
	[PERS_ID] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[LOKATIE_ID] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL ,
	[KAMER] [varchar] (20) COLLATE Latin1_General_BIN NULL ,
	[TELEFOONNR] [varchar] (11) COLLATE Latin1_General_BIN NULL ,
	[AFWEZIG] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDOPR_ID] [varchar] (8) COLLATE Latin1_General_BIN NULL ,
	[LASTUPDDTTM] [datetime] NULL 
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

ALTER TABLE [dbo].[FUNCTIES] ADD 
	CONSTRAINT [PK_FUNCTIES] PRIMARY KEY  NONCLUSTERED 
	(
		[FUNCTIE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOKATIES] ADD 
	CONSTRAINT [PK_LOKATIES] PRIMARY KEY  NONCLUSTERED 
	(
		[LOKATIE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[UNITS] ADD 
	CONSTRAINT [PK_UNITS] PRIMARY KEY  NONCLUSTERED 
	(
		[UNIT_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERSONEEL] ADD 
	CONSTRAINT [PK_PERSONEEL] PRIMARY KEY  NONCLUSTERED 
	(
		[PERS_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERS_LOK] ADD 
	CONSTRAINT [PK_PERS_LOK] PRIMARY KEY  NONCLUSTERED 
	(
		[PERS_ID],
		[LOKATIE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERSONEEL] ADD 
	CONSTRAINT [FK_PERSONEEL_FUNCTIES] FOREIGN KEY 
	(
		[FUNCTIE_ID]
	) REFERENCES [dbo].[FUNCTIES] (
		[FUNCTIE_ID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_PERSONEEL_UNITS] FOREIGN KEY 
	(
		[UNIT_ID]
	) REFERENCES [dbo].[UNITS] (
		[UNIT_ID]
	) NOT FOR REPLICATION 
GO

alter table [dbo].[PERSONEEL] nocheck constraint [FK_PERSONEEL_FUNCTIES]
GO

alter table [dbo].[PERSONEEL] nocheck constraint [FK_PERSONEEL_UNITS]
GO

ALTER TABLE [dbo].[PERS_LOK] ADD 
	CONSTRAINT [FK_PERS_LOK_LOKATIES] FOREIGN KEY 
	(
		[LOKATIE_ID]
	) REFERENCES [dbo].[LOKATIES] (
		[LOKATIE_ID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_PERS_LOK_PERSONEEL] FOREIGN KEY 
	(
		[PERS_ID]
	) REFERENCES [dbo].[PERSONEEL] (
		[PERS_ID]
	) NOT FOR REPLICATION 
GO

alter table [dbo].[PERS_LOK] nocheck constraint [FK_PERS_LOK_LOKATIES]
GO

alter table [dbo].[PERS_LOK] nocheck constraint [FK_PERS_LOK_PERSONEEL]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW _qEXPORT AS
SELECT P.PERS_ID, 
	S.AANHEF, 
	EP.SEXE, 
	EP.VOORLETTERS AS VOORLETTER, 
	EP.VOORNAAM AS ROEPNAAM, 
	'' AS VOORVOEG, 
	EP.VOLLEDIGENAAM AS ACHTERNAAM, 
	SK.UNIT AS AFDELING, 
	EP.FUNCTIE, 
	SK.LOCATIE AS [OBJECT], 
	PL.TELEFOONNR AS TELNR, 
	P.PERS_ID+'@alfa-college.nl' AS EMAIL, 
	EP.EXT_PERS_ID AS EDUKAATNR
FROM (_SORTKENMERK SK INNER JOIN 
	(_SEXE S INNER JOIN 
		(PERSONEEL P INNER JOIN EXT_PERSONEEL EP
		ON P.EXT_PERS_ID = EP.EXT_PERS_ID) 
	ON S.SEXE = EP.SEXE) 
ON SK.SORTKENMERK = EP.SORTKENMERK) LEFT OUTER JOIN PERS_LOK PL
ON (PL.PERS_ID = P.PERS_ID AND PL.LOKATIE_ID = SUBSTRING(SK.LOCATIE,1,4) )


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


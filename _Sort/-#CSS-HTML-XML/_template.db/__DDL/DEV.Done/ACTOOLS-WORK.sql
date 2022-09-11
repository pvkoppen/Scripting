if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AC_UImport_CAMPUS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AC_UImport_CAMPUS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[NEWORGID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NEWORGID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[NEWPERSID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NEWPERSID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACDW].[DN_STATUS]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ACDW].[DN_STATUS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACDW].[ACTIEVE_DN]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ACDW].[ACTIEVE_DN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACDW].[ACTIEVE_DN2]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ACDW].[ACTIEVE_DN2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACDW].[ACTIEVE_DN_PERSINFO]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ACDW].[ACTIEVE_DN_PERSINFO]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACDW].[AC_SYSJOBS]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ACDW].[AC_SYSJOBS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACDW].[DN_PROGSTATUS]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ACDW].[DN_PROGSTATUS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_Base]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_Base]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_FUNC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_FUNC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_NAW]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_NAW]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_SORT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_SORT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_SORT_BCK]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_SORT_BCK]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_SORT_BCK-20041007]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_SORT_BCK-20041007]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AB_SORT_TMP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AB_SORT_TMP]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CONTROLELOGS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CONTROLELOGS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Demo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Demo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EDUCAT_EMPIDS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EDUCAT_EMPIDS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EDUCAT_EMPIDS_MDA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EDUCAT_EMPIDS_MDA]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IN_PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IN_PERSONEEL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TD_HARDWARE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TD_HARDWARE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TD_PERSONEEL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TD_PERSONEEL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Table1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Table1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[rooster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[rooster]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[xls-sortcodes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[xls-sortcodes]
GO

if exists (select * from dbo.systypes where name = N'PSDATE')
exec sp_droptype N'PSDATE'
GO

setuser
GO

EXEC sp_addtype N'PSDATE', N'datetime', N'null'
GO

setuser
GO

CREATE TABLE [dbo].[AB_Base] (
	[stamnr] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[dv_datum_einde] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[datum] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[burgstaat] [nvarchar] (1) COLLATE Latin1_General_BIN NULL ,
	[geslacht] [nvarchar] (5) COLLATE Latin1_General_BIN NULL ,
	[roepnaam] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[naam] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[gebdatum] [smalldatetime] NULL ,
	[adres] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[huisnr] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[toevhuisnr] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[postcode] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[plaats] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[TelnrPrive] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[TelnrWerk] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[afkorting] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[functiecode] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[functie] [nvarchar] (75) COLLATE Latin1_General_BIN NULL ,
	[SdvNr] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[cso] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[kpl] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[factor] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[locatie] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[sortkenm] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[OECODE_1] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[LOCCODE_1] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[dv_reden] [nvarchar] (2) COLLATE Latin1_General_BIN NULL ,
	[actief] [char] (1) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_FUNC] (
	[code] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[descr] [nvarchar] (75) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_NAW] (
	[stamnr] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[gebdatum] [smalldatetime] NULL ,
	[EersteVoornaam] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[OverigeVoornamen] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[relatiecode] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[voorl] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[vvp] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[NaamPartner] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[vv] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[eigennaam] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[vv_voluit] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[vvp_voluit] [nvarchar] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_SORT] (
	[sortkenmerk] [nvarchar] (50) COLLATE Latin1_General_BIN NOT NULL ,
	[afdeling] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[locatie] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[unit] [nvarchar] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_SORT_BCK] (
	[sortkenmerk] [nvarchar] (50) COLLATE Latin1_General_BIN NOT NULL ,
	[afdeling] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[locatie] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[unit] [nvarchar] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_SORT_BCK-20041007] (
	[sortkenmerk] [nvarchar] (50) COLLATE Latin1_General_BIN NOT NULL ,
	[afdeling] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[locatie] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[unit] [nvarchar] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AB_SORT_TMP] (
	[sortkenmerk] [nvarchar] (50) COLLATE Latin1_General_BIN NOT NULL ,
	[afdeling] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[locatie] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[unit] [nvarchar] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CONTROLELOGS] (
	[CTLDESCR] [varchar] (100) COLLATE Latin1_General_BIN NULL ,
	[DATUM] [datetime] NULL ,
	[RESULT] [int] NULL ,
	[RESDESCR] [varchar] (100) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Demo] (
	[Demo] [varchar] (50) COLLATE Latin1_General_BIN NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EDUCAT_EMPIDS] (
	[EMPLID] [char] (11) COLLATE Latin1_General_BIN NOT NULL ,
	[CAMPUS] [varchar] (10) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EDUCAT_EMPIDS_MDA] (
	[EMPLID] [char] (11) COLLATE Latin1_General_BIN NOT NULL ,
	[CAMPUS] [varchar] (10) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IN_PERSONEEL] (
	[ACTOOLSID] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[STAMNR] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[PERSID] [varchar] (12) COLLATE Latin1_General_BIN NULL ,
	[TITELVOOR] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[ROEPNAAM] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[VOORNAAM] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[VOORNAAM2] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[VOORLETTERS] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[TUSSENVOEGSEL] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[ACHTERNAAM] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[TITELNA] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[TUSSENVPARTNER] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[ACHTERNPARTNER] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PREFNAAM] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[VOLLENAAM] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PREFTUSSENV] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PREFACHTERN] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[GEBDATUM] [datetime] NULL ,
	[GESLACHT] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PRIVETELNR] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PRIVEADRES] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PRIVEHUISNR] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PRIVEPOSTCODE] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[PRIVEWOONPLAATS] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[BURGSTAAT] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[MUTATIEDATUM] [datetime] NULL ,
	[SORTKENMERK] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[FUNCTIETYPECODE] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[FUNCTIETYPE] [varchar] (75) COLLATE Latin1_General_BIN NULL ,
	[FUNCTIECODE] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[FUNCTIE] [varchar] (75) COLLATE Latin1_General_BIN NULL ,
	[STANDPLAATS] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[STAMLOCATIE] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[STAMUNIT] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[SDVNR] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[KOSTPLAATSCODE] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[KOSTPLAATS] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[KOSTFACTOR] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[EMAIL] [varchar] (50) COLLATE Latin1_General_BIN NULL ,
	[WERKTELNR] [varchar] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TD_HARDWARE] (
	[objectid] [nvarchar] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[configuratie] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[budgethouder] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[soort] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[specificatie] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[installatie] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[serienummer] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[leverancier] [nvarchar] (60) COLLATE Latin1_General_BIN NULL ,
	[aanschaf] [datetime] NULL ,
	[garantietot] [datetime] NULL ,
	[verzekerdtot] [datetime] NULL ,
	[aankoopbedrag] [money] NULL ,
	[restwaarde] [money] NULL ,
	[afschrijvenin] [int] NULL ,
	[status] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[ipadres] [nvarchar] (20) COLLATE Latin1_General_BIN NULL ,
	[hostnaam] [nvarchar] (20) COLLATE Latin1_General_BIN NULL ,
	[millenniumproof] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[processor] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[kloksnelheid] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[hardeschijf] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[partities] [int] NULL ,
	[interngeheugen] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[soortgeheugen] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[geheugenbanken] [int] NULL ,
	[ingebruik] [int] NULL ,
	[diversen] [text] COLLATE Latin1_General_BIN NULL ,
	[merk1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[serienummer1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[serienummer2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk3] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type3] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk4] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type4] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk5] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type5] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[adres] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk6] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type6] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[baudrate] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[type7] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[merk7] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[snelheid] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[aantekeningen] [text] COLLATE Latin1_General_BIN NULL ,
	[tekst1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst3] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst4] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst5] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[opzoeklijst1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[opzoeklijst2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[opzoeklijst3] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[getal1] [float] NULL ,
	[getal2] [float] NULL ,
	[datum1] [datetime] NULL ,
	[datum2] [datetime] NULL ,
	[logisch1] [bit] NULL ,
	[logisch2] [bit] NULL ,
	[logisch3] [bit] NULL ,
	[logisch4] [bit] NULL ,
	[logisch5] [bit] NULL ,
	[aantekeningen1] [text] COLLATE Latin1_General_BIN NULL ,
	[aantekeningen2] [text] COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[TD_PERSONEEL] (
	[personeeli] [nvarchar] (50) COLLATE Latin1_General_BIN NOT NULL ,
	[voornamen] [nvarchar] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[achternaam] [nvarchar] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[voorletters] [nvarchar] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[tussenvoegsels] [nvarchar] (10) COLLATE Latin1_General_BIN NULL ,
	[vestiging] [nvarchar] (60) COLLATE Latin1_General_BIN NULL ,
	[locatie] [nvarchar] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[afdeling] [nvarchar] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[budgethouder] [nvarchar] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[titel] [nvarchar] (10) COLLATE Latin1_General_BIN NULL ,
	[geslacht] [int] NULL ,
	[functie] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[personeelsnr] [nvarchar] (20) COLLATE Latin1_General_BIN NULL ,
	[mobiel] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[telefoon] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[fax] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[email] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[netwerk] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[mainframe] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[diversen] [ntext] COLLATE Latin1_General_BIN NULL ,
	[straat] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[nr] [nvarchar] (6) COLLATE Latin1_General_BIN NULL ,
	[postcode] [nvarchar] (15) COLLATE Latin1_General_BIN NULL ,
	[plaats] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[land] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[email2] [nvarchar] (50) COLLATE Latin1_General_BIN NULL ,
	[geboren] [nvarchar] (10) COLLATE Latin1_General_BIN NULL ,
	[telefoon1] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[telefoon2] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[mobiel2] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[fax2] [nvarchar] (25) COLLATE Latin1_General_BIN NULL ,
	[aantekeningen] [ntext] COLLATE Latin1_General_BIN NULL ,
	[tekst1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst3] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst4] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[tekst5] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[opzoeklijst1] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[opzoeklijst2] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[opzoeklijst3] [nvarchar] (30) COLLATE Latin1_General_BIN NULL ,
	[getal1] [int] NULL ,
	[getal2] [int] NULL ,
	[datum1] [nvarchar] (10) COLLATE Latin1_General_BIN NULL ,
	[datum2] [nvarchar] (10) COLLATE Latin1_General_BIN NULL ,
	[logisch1] [int] NULL ,
	[logisch2] [int] NULL ,
	[logisch3] [int] NULL ,
	[logisch4] [int] NULL ,
	[logisch5] [int] NULL ,
	[aantekeningen1] [ntext] COLLATE Latin1_General_BIN NULL ,
	[aantekeningen2] [ntext] COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Table1] (
	[test] [char] (10) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[rooster] (
	[Col001] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col002] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col003] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col004] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col005] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col006] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col007] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col008] [varchar] (255) COLLATE Latin1_General_BIN NULL ,
	[Col009] [varchar] (255) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[xls-sortcodes] (
	[Overzicht sorteercodes €duKaat] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F2] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F3] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F4] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F5] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F6] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F7] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F8] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F9] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F10] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F11] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F12] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F13] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F14] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F15] [nvarchar] (255) COLLATE Latin1_General_BIN NULL ,
	[F16] [nvarchar] (255) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TD_PERSONEEL] WITH NOCHECK ADD 
	CONSTRAINT [PK_PersoneelTopdesk] PRIMARY KEY  CLUSTERED 
	(
		[personeeli]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

setuser N'ACDW'
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
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

setuser N'ACDW'
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
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

setuser N'ACDW'
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
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

setuser N'ACDW'
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
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

setuser N'ACDW'
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
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

setuser N'ACDW'
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
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
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


CREATE TABLE [dbo].[Afdelingen] (
	[AfdelingCD] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[OEcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Naam] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Agenda] (
	[ItemID] [int] NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AfdelingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Vermelding] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MeerInfo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Start] [smalldatetime] NULL ,
	[Eind] [smalldatetime] NULL ,
	[Invoer] [smalldatetime] NULL ,
	[AuteurID] [int] NULL ,
	[Medewerkers] [bit] NOT NULL ,
	[Deelnemers] [bit] NOT NULL ,
	[Extern] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Alerts] (
	[AlertID] [int] NOT NULL ,
	[SessionID] [int] NOT NULL ,
	[DatumTijd] [smalldatetime] NOT NULL ,
	[Pagina] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Oorzaak] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BeheerID] [int] NULL ,
	[Commentaar] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Afgehandeld] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AuteursCategorieen] (
	[CatCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Omschrijving] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Prive] [bit] NOT NULL ,
	[userID] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Begrippen] (
	[BegripID] [int] NOT NULL ,
	[FeedbackID] [int] NULL ,
	[AuteurID] [int] NULL ,
	[Datum] [smalldatetime] NULL ,
	[Begrip] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Omschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Bookmarks] (
	[BookmarkID] [int] NOT NULL ,
	[CategorieID] [int] NULL ,
	[UserID] [int] NULL ,
	[URL] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Omschrijving] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Volgnummer] [tinyint] NULL ,
	[DatumTijd] [smalldatetime] NULL ,
	[Tip] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Bookmarks_Categorieen] (
	[CategorieID] [int] NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CatCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[UserID] [int] NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Sorteer] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Deelnemers] [bit] NOT NULL ,
	[Rechten] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Bookmarks_log] (
	[BookmarkID] [int] NOT NULL ,
	[Datum] [smalldatetime] NOT NULL ,
	[Response_tijd] [int] NULL ,
	[Melding] [int] NULL ,
	[Feedback] [smalldatetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Conferenties_Auteurs] (
	[userID] [int] NOT NULL ,
	[conferentieID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Conferenties_Overzicht] (
	[id] [int] NOT NULL ,
	[naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[thema] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[startdatum] [smalldatetime] NULL ,
	[einddatum] [smalldatetime] NULL ,
	[lokatie] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[url] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[datum_laatste_invoer] [smalldatetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Conferenties_Verslagen] (
	[id] [int] NOT NULL ,
	[titel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[userID] [int] NULL ,
	[datum_ingevoerd] [smalldatetime] NULL ,
	[doelgroep] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[soort] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[onderwerpen] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[start_presentatie] [smalldatetime] NULL ,
	[einde_presentatie] [smalldatetime] NULL ,
	[beschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[toepasbaarheid] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[materialen] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[presentator] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[mening] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[conferentieID] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Crebo] (
	[CreboCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Naam] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Deelnemers_Klassen] (
	[UserID] [int] NOT NULL ,
	[OpleidingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Leerweg] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[KlasCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LesgroepCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Documenten] (
	[DocumentID] [int] NOT NULL ,
	[CategorieID] [int] NULL ,
	[StatusID] [tinyint] NOT NULL ,
	[SoortID] [tinyint] NOT NULL ,
	[UserID] [int] NULL ,
	[Document] [image] NULL ,
	[Doc_filename] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Doc_filesize] [int] NULL ,
	[Doc_hash] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DatumTijd] [smalldatetime] NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Omschrijving] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Wachtwoord] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Documenten_Categorieen] (
	[CategorieID] [int] NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CatCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[UserID] [int] NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Sorteer] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Deelnemers] [bit] NOT NULL ,
	[Rechten] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Documenten_Soorten] (
	[SoortID] [tinyint] NOT NULL ,
	[Volgnummer] [tinyint] NOT NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Documenten_Status] (
	[StatusID] [tinyint] NOT NULL ,
	[Volgnummer] [tinyint] NOT NULL ,
	[Omschrijving] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Afbeelding] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HTTP_errors] (
	[http_code] [smallint] NOT NULL ,
	[omschrijving] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IP_intern] (
	[IP] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Klassen] (
	[KlasCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AfdelingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[MentorID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Lesgroepen] (
	[LesgroepCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AfdelingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Locaties] (
	[LOCcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ParentLOC] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Naam] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BezoekAdres] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BezoekPostcode] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BezoekPlaats] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PostAdres] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PostPostcode] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PostPlaats] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Telefoon] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Introtekst] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Repro] [bit] NOT NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[MW_tarieven] (
	[CategorieCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Uurtarief] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Mail] (
	[MailID] [int] NOT NULL ,
	[AfzenderID] [int] NULL ,
	[DatumTijd] [smalldatetime] NULL ,
	[Onderwerp] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bericht] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AfzenderGewist] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Mail_Attachments] (
	[AttachmentID] [int] NOT NULL ,
	[MailID] [int] NULL ,
	[Document] [image] NULL ,
	[Doc_filename] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Doc_filesize] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Mail_Ontvangers] (
	[MailID] [int] NOT NULL ,
	[OntvangerID] [int] NOT NULL ,
	[OntvangerGelezen] [bit] NOT NULL ,
	[OntvangerGewist] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Medewerkers_Afdelingen] (
	[UserID] [int] NOT NULL ,
	[AfdelingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Menu_intranet] (
	[OEcode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rol] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Niveau_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Niveau_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Niveau_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Volgnummer] [float] NULL ,
	[URL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Target] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Afbeelding] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Nieuws] (
	[NieuwsID] [int] NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CatCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AuteurID] [int] NULL ,
	[DatumInvoer] [smalldatetime] NULL ,
	[DatumBericht] [smalldatetime] NULL ,
	[DatumVerval] [smalldatetime] NULL ,
	[Koptekst] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Subkoptekst] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Nieuwsbericht] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[URL] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NieuwVenster] [bit] NOT NULL ,
	[Tip] [bit] NOT NULL ,
	[Deelnemers] [bit] NOT NULL ,
	[Medewerkers] [bit] NOT NULL ,
	[Extern] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Nieuws_Afbeeldingen] (
	[AfbeeldingID] [int] NOT NULL ,
	[NieuwsID] [int] NULL ,
	[Afbeelding] [image] NULL ,
	[Afb_filename] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Afb_align] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Afb_width] [smallint] NULL ,
	[Afb_height] [smallint] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Nieuws_Documenten] (
	[DocumentID] [int] NOT NULL ,
	[NieuwsID] [int] NULL ,
	[Document] [image] NULL ,
	[Doc_filename] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Doc_filesize] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[OER_deelkwalificatie] (
	[DkID] [int] NOT NULL ,
	[DkID_ref] [int] NULL ,
	[OplID] [int] NULL ,
	[DkNaam] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DkCode] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Crebo_dk] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Verplicht_BAK] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Verplicht] [bit] NOT NULL ,
	[Verplicht_opm] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opmerkingen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Extern] [bit] NOT NULL ,
	[SBU_som] [int] NULL ,
	[UserID] [int] NULL ,
	[Datum] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[OER_medewerkers] (
	[DkID] [int] NOT NULL ,
	[UserID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OER_module] (
	[ModID] [int] NOT NULL ,
	[ModID_ref] [int] NULL ,
	[DkID] [int] NULL ,
	[Moduulcode] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Moduulnaam] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Verplicht] [bit] NOT NULL ,
	[Verplicht_opm] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Van_blok] [tinyint] NULL ,
	[Van_blokweek_nr] [tinyint] NULL ,
	[Tot_blok] [tinyint] NULL ,
	[Tot_blokweek_nr] [tinyint] NULL ,
	[Lesuren] [smallint] NULL ,
	[Begeleidingsuren] [smallint] NULL ,
	[Toetsuren] [smallint] NULL ,
	[Excursieuren] [smallint] NULL ,
	[BPVuren] [smallint] NULL ,
	[Huiswerkuren] [smallint] NULL ,
	[Meer_jaren] [bit] NOT NULL ,
	[Voorkennis] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Instapniveau] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Didactische_werkvormen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hulpmiddelen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opmerkingen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserID] [int] NULL ,
	[Datum] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[OER_opleiding] (
	[OplID] [int] NOT NULL ,
	[OplID_ref] [int] NULL ,
	[OplNaam] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Lokatie] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Crebo_opl] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Leerweg] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Niveau] [tinyint] NULL ,
	[CohortStart] [smalldatetime] NULL ,
	[Opmerkingen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Vastgesteld_blok] [tinyint] NOT NULL ,
	[Edit_blok] [tinyint] NOT NULL ,
	[Vastgesteld] [bit] NOT NULL ,
	[UserID] [int] NULL ,
	[Datum] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[OER_toets] (
	[ToetsID] [int] NOT NULL ,
	[ToetsID_ref] [int] NULL ,
	[ModID] [int] NULL ,
	[Toetscode] [nvarchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Wegingsfactor] [decimal](5, 2) NULL ,
	[Bloknummer] [nvarchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Blokweeknummer] [nvarchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Onderwerp] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Inhoud] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Toetsvorm] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ToetsvormID] [tinyint] NULL ,
	[CentraleToets] [bit] NOT NULL ,
	[Toetsduur] [smallint] NULL ,
	[Eindtermen] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SBU] [smallint] NULL ,
	[Opmerkingen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserID] [int] NULL ,
	[Datum] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[OER_toetsvormen] (
	[ToetsvormID] [tinyint] NOT NULL ,
	[Omschrijving] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ORG_Locaties] (
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LOCcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OmschrijvingUsers] (
	[UserID] [int] NOT NULL ,
	[OmschrijvingMW] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OmschrijvingMWactief] [bit] NOT NULL ,
	[OmschrijvingDN] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OmschrijvingDNactief] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Opleidingen] (
	[OpleidingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AfdelingCD] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreboCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Naam] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OpleidingenInfo] (
	[OpleidingID] [int] NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CohortStart] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Niveau] [tinyint] NULL ,
	[Leerweg] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Crebo_opl] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OplNaam] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Beroepsbeschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Werkveldbeschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opleidingsbeschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Doorstroommogelijkheid] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Vooropleiding] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AanvullendeEisen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[brochure] [bit] NOT NULL ,
	[Disabled] [bit] NOT NULL ,
	[Trefwoorden] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserId] [int] NULL ,
	[Kosten] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Locatie] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Dagdelen] [int] NULL ,
	[Memo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[OrgEenheden] (
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ParentOE] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Naam] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[URL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Introtekst] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Stijlcode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[userID] [int] NULL ,
	[OER] [bit] NOT NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[PWD_dictionary] (
	[Password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PZ_bullArt] (
	[ArtikelID] [int] NOT NULL ,
	[BulletinID] [int] NULL ,
	[DatumTijd] [smalldatetime] NULL ,
	[Koptekst] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ArtikelTekst] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Samenvatting] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactID] [int] NULL ,
	[Volgnummer] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[PZ_bulletins] (
	[BulletinID] [int] NOT NULL ,
	[BulletinNr] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bijschrift] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Datum] [smalldatetime] NULL ,
	[Status] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PZ_medewerkers] (
	[UserID] [int] NOT NULL ,
	[Functie] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PZ_schalen] (
	[Schaal] [tinyint] NOT NULL ,
	[Functietype] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Minimaal] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Maximaal] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PZ_vacatures] (
	[VacatureID] [int] NOT NULL ,
	[Plaatsingsdatum] [smalldatetime] NULL ,
	[Sluitingsdatum] [smalldatetime] NULL ,
	[OEcode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Functienaam] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FunctieType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Dienstverband] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Omvang_1] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Omvang_2] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FunctieInhoud] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Vereisten] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Geboden] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bijzonderheden] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Schaal] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactID] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Pageviews] (
	[Id] [int] NOT NULL ,
	[Pagina] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Querystring] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Referer] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DatumTijd] [smalldatetime] NOT NULL ,
	[SessionID] [int] NOT NULL ,
	[IIS_sessionID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Pasfotos] (
	[UserID] [int] NOT NULL ,
	[Foto] [image] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Projectbegroting] (
	[BegrotingID] [int] NOT NULL ,
	[ProjectID] [int] NOT NULL ,
	[Aanvrager] [int] NULL ,
	[DatumAanvraag] [smalldatetime] NULL ,
	[StartDatum] [smalldatetime] NULL ,
	[EindDatum] [smalldatetime] NULL ,
	[UrenOP] [smallint] NULL ,
	[UrenOBP] [smallint] NULL ,
	[UrenOVH] [smallint] NULL ,
	[MK_kosten] [int] NULL ,
	[MK_kosten_hfl] [int] NULL ,
	[MK_omschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DE_kosten] [int] NULL ,
	[DE_kosten_hfl] [int] NULL ,
	[DE_omschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ROC_bijdrage] [int] NULL ,
	[ROC_bijdrage_hfl] [int] NULL ,
	[Externe_bijdrage] [int] NULL ,
	[Externe_bijdrage_hfl] [int] NULL ,
	[Participanten] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opm_aanvraag] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opm_beoordeling] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Status] [tinyint] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Projecten] (
	[ProjectID] [int] NOT NULL ,
	[Projectnummer] [smallint] NOT NULL ,
	[Projectsoort] [tinyint] NULL ,
	[Projectnaam] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Doelstellingen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Producten] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Afdeling] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Aanvrager] [int] NULL ,
	[Projectleider] [int] NULL ,
	[Participanten] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DatumAanvraag] [smalldatetime] NULL ,
	[DatumStart] [smalldatetime] NULL ,
	[DatumTussen_1] [smalldatetime] NULL ,
	[DatumTussen_2] [smalldatetime] NULL ,
	[DatumTussen_3] [smalldatetime] NULL ,
	[DatumEind] [smalldatetime] NULL ,
	[UrenOP] [smallint] NULL ,
	[UrenOBP] [smallint] NULL ,
	[UrenOVH] [smallint] NULL ,
	[MK_kosten] [int] NULL ,
	[MK_kosten_hfl] [int] NULL ,
	[MK_omschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DE_kosten] [int] NULL ,
	[DE_kosten_hfl] [int] NULL ,
	[DE_omschrijving] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ROC_bijdrage1] [int] NOT NULL ,
	[ROC_bijdrage1_hfl] [int] NULL ,
	[ROC_bijdrage2] [int] NOT NULL ,
	[ROC_bijdrage2_hfl] [int] NULL ,
	[Externe_bijdrage] [int] NULL ,
	[Externe_bijdrage_hfl] [int] NULL ,
	[Opm_aanvraag] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opm_beoordeling] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Status] [tinyint] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Projectmedewerkers] (
	[Id] [int] NOT NULL ,
	[ProjectID] [int] NULL ,
	[UserID] [int] NULL ,
	[StartDatum] [smalldatetime] NULL ,
	[EindDatum] [smalldatetime] NULL ,
	[Uren] [smallint] NULL ,
	[Bijzonderheden] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Status] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Projectsoorten] (
	[Projectsoort] [tinyint] NOT NULL ,
	[Omschrijving] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AfdrachtA12] [float] NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Projectstatus] (
	[Status] [tinyint] NOT NULL ,
	[Omschrijving] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Repro] (
	[OpdrachtID] [int] NOT NULL ,
	[UserID] [int] NULL ,
	[KostenplaatsID] [int] NULL ,
	[DatumVerzonden] [smalldatetime] NULL ,
	[DatumGereed] [smalldatetime] NULL ,
	[Document] [image] NULL ,
	[Doc_filename] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Doc_filesize] [int] NULL ,
	[Aantal] [smallint] NULL ,
	[Dubbelzijdig] [bit] NOT NULL ,
	[Sorteren] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Perforeren] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Nieten] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Inbinden] [bit] NOT NULL ,
	[Omslag] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opmerkingen] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReproUserID] [int] NULL ,
	[StatusCode] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DatumStatus] [smalldatetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Repro_codes] (
	[KostenplaatsID] [int] NOT NULL ,
	[Code] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[OEcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Volgnummer] [smallint] NOT NULL ,
	[Omschrijving] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Repro_status] (
	[Statuscode] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Volgnummer] [tinyint] NULL ,
	[Omschrijving] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sessions] (
	[SessionID] [int] NOT NULL ,
	[IIS_SessionID] [int] NULL ,
	[UserID] [int] NULL ,
	[StartTijd] [smalldatetime] NULL ,
	[Duur] [smallint] NULL ,
	[IP] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Via] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Intern] [bit] NOT NULL ,
	[MSIE] [bit] NOT NULL ,
	[OS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Stafmedewerkers] (
	[UserID] [int] NOT NULL ,
	[Functie] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PZ_vacatures] [bit] NOT NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Usermutatie_items] (
	[MutatieID] [int] NOT NULL ,
	[StamID] [int] NULL ,
	[Veldnaam] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Waarde_Oud] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Waarde_Nieuw] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Usermutatie_stam] (
	[StamID] [int] NOT NULL ,
	[UserID] [int] NULL ,
	[AdminID] [int] NULL ,
	[Verzonden] [smalldatetime] NULL ,
	[Bewerkt] [smalldatetime] NULL ,
	[OpmerkingUser] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OpmerkingAdmin] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IntraData] [bit] NOT NULL ,
	[AdminData] [bit] NOT NULL ,
	[Afgehandeld] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Users] (
	[UserID] [int] IDENTITY (1, 1) NOT NULL ,
	[AdminCD] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Usernaam] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Wachtwoord] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rol] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rechten] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[M_V] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Titel] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Voorletters] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Voornaam] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Tussen] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Achternaam] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Geb_datum] [datetime] NULL ,
	[Adres] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Postcode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Plaats] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AdrOpenbaar] [bit] NOT NULL ,
	[EmailWerk] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailPrive] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailStd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ForwardIntramail] [bit] NOT NULL ,
	[Url] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UrlActief] [bit] NOT NULL ,
	[TelefoonWerk_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TelefoonWerk_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TelefoonPrive_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TelefoonPrive_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TelOpenbaar] [bit] NOT NULL ,
	[OEcode_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OEcode_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCcode_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOCcode_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[KamerNr] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Actief] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Verzoeken] (
	[PERSID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Volgnummer] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[VerzoekDatum] [smalldatetime] NULL ,
	[Onderwerp] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Verzoek] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Behandelaar] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ActieDatum] [smalldatetime] NULL ,
	[Status] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WebsiteNet] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WebsiteAcc] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WebsiteDev] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Opmerking] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Verwijderd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


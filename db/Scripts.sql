USE [IAS]
GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbgraph', @level1type=N'VIEW',@level1name=N'DemoIncidentsViewEn'
GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbgraph', @level1type=N'VIEW',@level1name=N'DemoIncidentsViewEn'
GO
/****** Object:  StoredProcedure [dbgraph].[TraverseStep_MultiViews_PerViewExclude_Lang]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP PROCEDURE [dbgraph].[TraverseStep_MultiViews_PerViewExclude_Lang]
GO
/****** Object:  StoredProcedure [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP PROCEDURE [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang]
GO
/****** Object:  StoredProcedure [dbgraph].[SeedColumns_SyncCatalog]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP PROCEDURE [dbgraph].[SeedColumns_SyncCatalog]
GO
/****** Object:  StoredProcedure [dbgraph].[GetSeedValues]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP PROCEDURE [dbgraph].[GetSeedValues]
GO
/****** Object:  StoredProcedure [dbgraph].[GetSeedColumns]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP PROCEDURE [dbgraph].[GetSeedColumns]
GO
ALTER TABLE [dbgraph].[ViewColumnMap] DROP CONSTRAINT [FK_ViewColumnMap_ViewRegistry]
GO
ALTER TABLE [dbgraph].[SeedColumnCatalog] DROP CONSTRAINT [DF_SeedCol_LastSeen]
GO
ALTER TABLE [dbgraph].[SeedColumnCatalog] DROP CONSTRAINT [DF_SeedCol_FirstSeen]
GO
ALTER TABLE [dbgraph].[SeedColumnCatalog] DROP CONSTRAINT [DF_SeedCol_IsActive]
GO
/****** Object:  Index [UX_ViewRegistry_En]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP INDEX [UX_ViewRegistry_En] ON [dbgraph].[ViewRegistry]
GO
/****** Object:  Index [UX_ViewRegistry_Ar]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP INDEX [UX_ViewRegistry_Ar] ON [dbgraph].[ViewRegistry]
GO
/****** Object:  Table [dbgraph].[ViewRegistry]    Script Date: 11/6/2025 4:59:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbgraph].[ViewRegistry]') AND type in (N'U'))
DROP TABLE [dbgraph].[ViewRegistry]
GO
/****** Object:  Table [dbgraph].[ViewColumnMap]    Script Date: 11/6/2025 4:59:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbgraph].[ViewColumnMap]') AND type in (N'U'))
DROP TABLE [dbgraph].[ViewColumnMap]
GO
/****** Object:  Table [dbgraph].[SeedColumnCatalog]    Script Date: 11/6/2025 4:59:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbgraph].[SeedColumnCatalog]') AND type in (N'U'))
DROP TABLE [dbgraph].[SeedColumnCatalog]
GO
/****** Object:  View [dbgraph].[DemoIncidentsViewAr]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP VIEW [dbgraph].[DemoIncidentsViewAr]
GO
/****** Object:  View [dbgraph].[DemoIncidentsViewEn]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP VIEW [dbgraph].[DemoIncidentsViewEn]
GO
/****** Object:  Table [dbgraph].[DemoIncidents]    Script Date: 11/6/2025 4:59:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbgraph].[DemoIncidents]') AND type in (N'U'))
DROP TABLE [dbgraph].[DemoIncidents]
GO
/****** Object:  View [dbgraph].[CompanyViewAr]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP VIEW [dbgraph].[CompanyViewAr]
GO
/****** Object:  View [dbgraph].[EmployeeViewEn]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP VIEW [dbgraph].[EmployeeViewEn]
GO
/****** Object:  View [dbgraph].[EmployeeViewAr]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP VIEW [dbgraph].[EmployeeViewAr]
GO
/****** Object:  View [dbgraph].[CompanyViewEn]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP VIEW [dbgraph].[CompanyViewEn]
GO
/****** Object:  Table [dbgraph].[DemoRows]    Script Date: 11/6/2025 4:59:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbgraph].[DemoRows]') AND type in (N'U'))
DROP TABLE [dbgraph].[DemoRows]
GO
/****** Object:  UserDefinedTableType [dbgraph].[ViewColValPair]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP TYPE [dbgraph].[ViewColValPair]
GO
/****** Object:  UserDefinedTableType [dbgraph].[IntList]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP TYPE [dbgraph].[IntList]
GO
/****** Object:  UserDefinedTableType [dbgraph].[ColValPair]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP TYPE [dbgraph].[ColValPair]
GO
/****** Object:  Schema [dbgraph]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP SCHEMA [dbgraph]
GO
USE [master]
GO
/****** Object:  Database [IAS]    Script Date: 11/6/2025 4:59:18 PM ******/
DROP DATABASE [IAS]
GO
/****** Object:  Database [IAS]    Script Date: 11/6/2025 4:59:18 PM ******/
CREATE DATABASE [IAS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'IAS', FILENAME = N'C:\Users\prasanth.s\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\IAS_Primary.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'IAS_log', FILENAME = N'C:\Users\prasanth.s\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\IAS_Primary.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [IAS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [IAS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [IAS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [IAS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [IAS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [IAS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [IAS] SET ARITHABORT OFF 
GO
ALTER DATABASE [IAS] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [IAS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [IAS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [IAS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [IAS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [IAS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [IAS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [IAS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [IAS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [IAS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [IAS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [IAS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [IAS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [IAS] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [IAS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [IAS] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [IAS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [IAS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [IAS] SET  MULTI_USER 
GO
ALTER DATABASE [IAS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [IAS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [IAS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [IAS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [IAS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [IAS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [IAS] SET QUERY_STORE = OFF
GO
USE [IAS]
GO
/****** Object:  Schema [dbgraph]    Script Date: 11/6/2025 4:59:18 PM ******/
CREATE SCHEMA [dbgraph]
GO
/****** Object:  UserDefinedTableType [dbgraph].[ColValPair]    Script Date: 11/6/2025 4:59:18 PM ******/
CREATE TYPE [dbgraph].[ColValPair] AS TABLE(
	[col] [sysname] NOT NULL,
	[val] [nvarchar](4000) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[col] ASC,
	[val] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [dbgraph].[IntList]    Script Date: 11/6/2025 4:59:18 PM ******/
CREATE TYPE [dbgraph].[IntList] AS TABLE(
	[id] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [dbgraph].[ViewColValPair]    Script Date: 11/6/2025 4:59:18 PM ******/
CREATE TYPE [dbgraph].[ViewColValPair] AS TABLE(
	[ViewID] [int] NOT NULL,
	[col] [sysname] NOT NULL,
	[val] [nvarchar](4000) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[ViewID] ASC,
	[col] ASC,
	[val] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  Table [dbgraph].[DemoRows]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgraph].[DemoRows](
	[NT_A] [nvarchar](128) NULL,
	[ID_AID] [nvarchar](4000) NULL,
	[TEXT_ATEXT] [nvarchar](max) NULL,
	[COLOR_A] [nvarchar](30) NULL,
	[NT_B] [nvarchar](128) NULL,
	[ID_BID] [nvarchar](4000) NULL,
	[TEXT_BTEXT] [nvarchar](max) NULL,
	[COLOR_B] [nvarchar](30) NULL,
	[NT_C] [nvarchar](128) NULL,
	[ID_CID] [nvarchar](4000) NULL,
	[TEXT_CTEXT] [nvarchar](max) NULL,
	[COLOR_C] [nvarchar](30) NULL,
	[NT_D] [nvarchar](128) NULL,
	[ID_DID] [nvarchar](4000) NULL,
	[TEXT_DTEXT] [nvarchar](max) NULL,
	[COLOR_D] [nvarchar](30) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbgraph].[CompanyViewEn]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* for demo we point both company views to the same rows table too */
CREATE VIEW [dbgraph].[CompanyViewEn]  AS
SELECT * FROM dbgraph.DemoRows;
GO
/****** Object:  View [dbgraph].[EmployeeViewAr]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbgraph].[EmployeeViewAr] AS
SELECT * FROM dbgraph.DemoRows;
GO
/****** Object:  View [dbgraph].[EmployeeViewEn]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbgraph].[EmployeeViewEn] AS
SELECT * FROM dbgraph.DemoRows;
GO
/****** Object:  View [dbgraph].[CompanyViewAr]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbgraph].[CompanyViewAr]  AS
SELECT * FROM dbgraph.DemoRows;
GO
/****** Object:  Table [dbgraph].[DemoIncidents]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgraph].[DemoIncidents](
	[NT_OperationType] [nvarchar](13) NULL,
	[ID_OperationTypeID] [int] NULL,
	[TEXT_OperationTypeTEXT] [nvarchar](12) NULL,
	[COLOR_OperationType] [nvarchar](7) NULL,
	[NT_IncidentType] [nvarchar](12) NULL,
	[ID_IncidentTypeID] [int] NULL,
	[TEXT_IncidentTypeTEXT] [nvarchar](10) NULL,
	[COLOR_IncidentType] [nvarchar](7) NULL,
	[NT_Organization] [nvarchar](12) NULL,
	[ID_OrganizationID] [int] NULL,
	[TEXT_OrganizationTEXT] [nvarchar](14) NULL,
	[COLOR_Organization] [nvarchar](7) NULL,
	[NT_Implement] [nvarchar](9) NULL,
	[ID_ImplementID] [int] NULL,
	[TEXT_ImplementTEXT] [nvarchar](11) NULL,
	[COLOR_Implement] [nvarchar](7) NULL,
	[NT_ImplementAganist] [nvarchar](16) NULL,
	[ID_ImplementAganistID] [int] NULL,
	[TEXT_ImplementAganistTEXT] [nvarchar](16) NULL,
	[COLOR_ImplementAganist] [nvarchar](7) NULL,
	[NT_Information] [nvarchar](11) NULL,
	[ID_InformationID] [int] NULL,
	[TEXT_InformationTEXT] [nvarchar](14) NULL,
	[COLOR_Information] [nvarchar](7) NULL,
	[NT_Character] [nvarchar](9) NULL,
	[ID_CharacterID] [int] NULL,
	[TEXT_CharacterTEXT] [nvarchar](15) NULL,
	[COLOR_Character] [nvarchar](7) NULL,
	[NT_Weapon] [nvarchar](6) NULL,
	[ID_WeaponID] [int] NULL,
	[TEXT_WeaponTEXT] [nvarchar](8) NULL,
	[COLOR_Weapon] [nvarchar](7) NULL,
	[NT_Country] [nvarchar](7) NULL,
	[ID_CountryID] [int] NULL,
	[TEXT_CountryTEXT] [nvarchar](7) NULL,
	[COLOR_Country] [nvarchar](8) NULL,
	[NT_State] [nvarchar](5) NULL,
	[ID_StateID] [int] NULL,
	[TEXT_StateTEXT] [nvarchar](7) NULL,
	[COLOR_State] [nvarchar](7) NULL,
	[NT_Region] [nvarchar](6) NULL,
	[ID_RegionID] [int] NULL,
	[TEXT_RegionTEXT] [nvarchar](16) NULL,
	[COLOR_Region] [nvarchar](7) NULL,
	[NT_Village] [nvarchar](7) NULL,
	[ID_VillageID] [int] NULL,
	[TEXT_VillageTEXT] [nvarchar](9) NULL,
	[COLOR_Village] [nvarchar](7) NULL,
	[NT_SourceType] [nvarchar](10) NULL,
	[ID_SourceTypeID] [int] NULL,
	[TEXT_SourceTypeTEXT] [nvarchar](8) NULL,
	[COLOR_SourceType] [nvarchar](8) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbgraph].[DemoIncidentsViewEn]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbgraph].[DemoIncidentsViewEn]
AS
SELECT       *
FROM            dbgraph.DemoIncidents
GO
/****** Object:  View [dbgraph].[DemoIncidentsViewAr]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbgraph].[DemoIncidentsViewAr]
AS
SELECT        *
FROM            dbgraph.DemoIncidents
GO
/****** Object:  Table [dbgraph].[SeedColumnCatalog]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgraph].[SeedColumnCatalog](
	[Column_ID] [sysname] NOT NULL,
	[ColumnEn] [nvarchar](200) NULL,
	[ColumnAr] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[FirstSeenAt] [datetime2](7) NOT NULL,
	[LastSeenAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_SeedColumnCatalog] PRIMARY KEY CLUSTERED 
(
	[Column_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgraph].[ViewColumnMap]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgraph].[ViewColumnMap](
	[ViewID] [int] NOT NULL,
	[ColumnName] [nvarchar](128) NOT NULL,
	[DisplayNameEn] [nvarchar](200) NOT NULL,
	[DisplayNameAr] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_ViewColumnMap] PRIMARY KEY CLUSTERED 
(
	[ViewID] ASC,
	[ColumnName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgraph].[ViewRegistry]    Script Date: 11/6/2025 4:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgraph].[ViewRegistry](
	[ViewID] [int] IDENTITY(1,1) NOT NULL,
	[ViewDescriptionEn] [nvarchar](200) NOT NULL,
	[ViewDescriptionAr] [nvarchar](200) NOT NULL,
	[ViewNameEn] [nvarchar](128) NOT NULL,
	[ViewNameAr] [nvarchar](128) NOT NULL,
	[ViewDB] [nvarchar](128) NOT NULL,
	[ViewSchema] [nvarchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ViewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', NULL, 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 238, N'tweterter', N'#00FFFF', N'ImplementAganist', 251, N'wqrwrwwr', N'#FF00FF', N'Information', 217, N'Information-81', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 7, N'test', N'#808000', N'Region', 218, N'sdfsf', N'#FFD700', N'Village', 219, N'sdfgdfg', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 238, N'tweterter', N'#00FFFF', N'ImplementAganist', 251, N'wqrwrwwr', N'#FF00FF', N'Information', 217, N'Information-81', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 214, N'Weapon 3', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 7, N'test', N'#808000', N'Region', 218, N'sdfsf', N'#FFD700', N'Village', 219, N'sdfgdfg', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 9, N'Operation 3', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 253, N'Information-82', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 9, N'Operation 3', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 253, N'Information-82', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 9, N'Operation 3', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 253, N'Information-82', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 9, N'Operation 3', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 253, N'Information-82', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 9, N'Operation 3', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 253, N'Information-82', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 9, N'Operation 3', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 253, N'Information-82', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 324, N'Information-85', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 325, N'Information-90', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', 328, N'test imp', N'#00FFFF', N'ImplementAganist', 329, N'test imp against', N'#FF00FF', N'Information', 327, N'Information-91', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', 8, N'State 1', N'#808000', N'Region', 63, N'Region 1', N'#FFD700', N'Village', 64, N'Village 1', N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 69, N'User 1', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 69, N'User 1', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 69, N'User 1', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 70, N'User 2', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 70, N'User 2', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 70, N'User 2', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 231, N'Implement 2', N'#00FFFF', N'ImplementAganist', 248, N'567575', N'#FF00FF', N'Information', 140, N'Information-1', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 233, N'Implement 4', N'#00FFFF', N'ImplementAganist', 245, N'457457', N'#FF00FF', N'Information', 142, N'Information-43', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 237, N'jutgj', N'#00FFFF', N'ImplementAganist', 242, N'23432423', N'#FF00FF', N'Information', 143, N'Information-44', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 234, N'Implement 5', N'#00FFFF', N'ImplementAganist', 246, N'457567', N'#FF00FF', N'Information', 144, N'Information-45', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 89, N'Test 1', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', 232, N'Implement 3', N'#00FFFF', N'ImplementAganist', 247, N'47554675', N'#FF00FF', N'Information', 146, N'Information-46', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 69, N'User 1', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 69, N'User 1', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 81, N'User 1', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 70, N'User 2', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 70, N'User 2', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 21, N'Operation 19', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', NULL, NULL, N'#FFFF00', N'Implement', 235, N'Implement 6', N'#00FFFF', N'ImplementAganist', 243, N'2w3423432', N'#FF00FF', N'Information', 147, N'Information-47', N'#FFA500', N'Character', 71, N'User 33', N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', 240, N'wqerwqer', N'#00FFFF', N'ImplementAganist', 244, N'45544', N'#FF00FF', N'Information', 149, N'Information-54', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', NULL, NULL, N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 390, N'Information-93', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 390, N'Information-93', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 214, N'Weapon 3', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 390, N'Information-93', N'#FFA500', N'Character', 90, N'test 444', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 390, N'Information-93', N'#FFA500', N'Character', 90, N'test 444', N'#800080', N'Weapon', 214, N'Weapon 3', N'#808080', N'Country', 237, N'Yemen', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 5, N'Operation 1', N'#008000', N'IncidentType', 6, N'Incident 1', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', 239, N'tytyu', N'#00FFFF', N'ImplementAganist', 252, N'wrweyrruy', N'#FF00FF', N'Information', 192, N'Information-55', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 212, N'Weapon 1', N'#808080', N'Country', 98, N'India', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', NULL, NULL, N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 7, N'Source 1', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 241, N'wqrewr', N'#00FFFF', N'ImplementAganist', 249, N'dfgd', N'#FF00FF', N'Information', 216, N'Information-80', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 214, N'Weapon 3', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', 12, N'werwrw', N'#808000', N'Region', 364, N'eretertee', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 241, N'wqrewr', N'#00FFFF', N'ImplementAganist', 249, N'dfgd', N'#FF00FF', N'Information', 216, N'Information-80', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', 12, N'werwrw', N'#808000', N'Region', 364, N'eretertee', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 241, N'wqrewr', N'#00FFFF', N'ImplementAganist', 249, N'dfgd', N'#FF00FF', N'Information', 216, N'Information-80', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 97, N'Weapon1', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', 12, N'werwrw', N'#808000', N'Region', 364, N'eretertee', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 8, N'Operation 2', N'#008000', N'IncidentType', 10, N'Incident 2', N'#0000FF', N'Organization', 27, N'Organization 2', N'#FFFF00', N'Implement', 241, N'wqrewr', N'#00FFFF', N'ImplementAganist', 249, N'dfgd', N'#FF00FF', N'Information', 216, N'Information-80', N'#FFA500', N'Character', NULL, NULL, N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', 12, N'werwrw', N'#808000', N'Region', 364, N'eretertee', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 366, N'Information-92', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', 367, N'fgvhbfvhfh ff fd', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 366, N'Information-92', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', 367, N'fgvhbfvhfh ff fd', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 366, N'Information-92', N'#FFA500', N'Character', 68, N'fgjhghj 999 545', N'#800080', N'Weapon', 214, N'Weapon 3', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', 367, N'fgvhbfvhfh ff fd', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 366, N'Information-92', N'#FFA500', N'Character', 90, N'test 444', N'#800080', N'Weapon', 213, N'Weapon 2', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', 367, N'fgvhbfvhfh ff fd', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 366, N'Information-92', N'#FFA500', N'Character', 90, N'test 444', N'#800080', N'Weapon', 98, N'Weapon2', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', 367, N'fgvhbfvhfh ff fd', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoIncidents] ([NT_OperationType], [ID_OperationTypeID], [TEXT_OperationTypeTEXT], [COLOR_OperationType], [NT_IncidentType], [ID_IncidentTypeID], [TEXT_IncidentTypeTEXT], [COLOR_IncidentType], [NT_Organization], [ID_OrganizationID], [TEXT_OrganizationTEXT], [COLOR_Organization], [NT_Implement], [ID_ImplementID], [TEXT_ImplementTEXT], [COLOR_Implement], [NT_ImplementAganist], [ID_ImplementAganistID], [TEXT_ImplementAganistTEXT], [COLOR_ImplementAganist], [NT_Information], [ID_InformationID], [TEXT_InformationTEXT], [COLOR_Information], [NT_Character], [ID_CharacterID], [TEXT_CharacterTEXT], [COLOR_Character], [NT_Weapon], [ID_WeaponID], [TEXT_WeaponTEXT], [COLOR_Weapon], [NT_Country], [ID_CountryID], [TEXT_CountryTEXT], [COLOR_Country], [NT_State], [ID_StateID], [TEXT_StateTEXT], [COLOR_State], [NT_Region], [ID_RegionID], [TEXT_RegionTEXT], [COLOR_Region], [NT_Village], [ID_VillageID], [TEXT_VillageTEXT], [COLOR_Village], [NT_SourceType], [ID_SourceTypeID], [TEXT_SourceTypeTEXT], [COLOR_SourceType]) VALUES (N'OperationType', 20, N'Operation 16', N'#008000', N'IncidentType', 11, N'Incident 3', N'#0000FF', N'Organization', 26, N'Organization 1', N'#FFFF00', N'Implement', NULL, NULL, N'#00FFFF', N'ImplementAganist', NULL, NULL, N'#FF00FF', N'Information', 366, N'Information-92', N'#FFA500', N'Character', 90, N'test 444', N'#800080', N'Weapon', 214, N'Weapon 3', N'#808080', N'Country', 4, N'America', N'	#FF7F50', N'State', NULL, NULL, N'#808000', N'Region', 367, N'fgvhbfvhfh ff fd', N'#FFD700', N'Village', NULL, NULL, N'#228B22', N'SourceType', 12, N'Source 2', N'	#4169E1')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', N'company', N'1', N'GAL', N'#00FF00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', NULL, NULL, NULL, NULL, N'Car', N'11', N'Rav 4', N'#FFFF00', NULL, NULL, NULL, NULL)
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', NULL, NULL, NULL, NULL, N'Car', N'12', N'Yaris', N'#FFFF00', NULL, NULL, NULL, NULL)
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Spouse', N'1', N'Mary', N'#008080')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Son', N'2', N'Johaan', N'#FFA500')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'2', N'Alex', N'#0000FF', N'company', N'2', N'GEMS', N'#00FF00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'2', N'Alex', N'#0000FF', NULL, NULL, NULL, NULL, N'Car', N'13', N'BYD', N'#FFFF00', NULL, NULL, NULL, NULL)
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'2', N'Alex', N'#0000FF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Spouse', N'3', N'Nayaomi', N'#008080')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'2', N'Alex', N'#0000FF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Son', N'4', N'Eric', N'#FFA500')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Son', N'5', N'Abram', N'#FFA500')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'2', N'Alex', N'#0000FF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'daughter', N'6', N'Jessica', N'#00FFFF')
GO
INSERT [dbgraph].[DemoRows] ([NT_A], [ID_AID], [TEXT_ATEXT], [COLOR_A], [NT_B], [ID_BID], [TEXT_BTEXT], [COLOR_B], [NT_C], [ID_CID], [TEXT_CTEXT], [COLOR_C], [NT_D], [ID_DID], [TEXT_DTEXT], [COLOR_D]) VALUES (N'Member', N'1', N'Prasanth', N'#0000FF', NULL, N'2', N'GEMS', N'#00FF00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_AID', N'Member', N'العضو', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_BID', N'Company', N'الشركة', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_CharacterID', N'ID_CharacterID', N'ID_CharacterID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_CID', N'Car', N'سيارة', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_CountryID', N'ID_CountryID', N'ID_CountryID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_DID', N'Family', N'عائلة', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_ImplementAganistID', N'ID_ImplementAganistID', N'ID_ImplementAganistID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_ImplementID', N'ID_ImplementID', N'ID_ImplementID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_IncidentTypeID', N'ID_IncidentTypeID', N'ID_IncidentTypeID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_InformationID', N'ID_InformationID', N'ID_InformationID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_OperationTypeID', N'ID_OperationTypeID', N'ID_OperationTypeID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_OrganizationID', N'ID_OrganizationID', N'ID_OrganizationID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_RegionID', N'ID_RegionID', N'ID_RegionID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_SourceTypeID', N'ID_SourceTypeID', N'ID_SourceTypeID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_StateID', N'ID_StateID', N'ID_StateID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_VillageID', N'ID_VillageID', N'ID_VillageID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[SeedColumnCatalog] ([Column_ID], [ColumnEn], [ColumnAr], [IsActive], [FirstSeenAt], [LastSeenAt]) VALUES (N'ID_WeaponID', N'ID_WeaponID', N'ID_WeaponID', 1, CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2), CAST(N'2025-11-06T05:46:37.0360254' AS DateTime2))
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (1, N'ID_AID', N'Member', N'العضو')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (1, N'ID_BID', N'Company', N'الشركة')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (1, N'ID_CID', N'Car', N'سيارة')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (1, N'ID_DID', N'Family', N'عائلة')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (2, N'ID_AID', N'Member', N'العضو')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (2, N'ID_BID', N'Company', N'الشركة')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (2, N'ID_CID', N'Car', N'سيارة')
GO
INSERT [dbgraph].[ViewColumnMap] ([ViewID], [ColumnName], [DisplayNameEn], [DisplayNameAr]) VALUES (2, N'ID_DID', N'Family', N'عائلة')
GO
SET IDENTITY_INSERT [dbgraph].[ViewRegistry] ON 
GO
INSERT [dbgraph].[ViewRegistry] ([ViewID], [ViewDescriptionEn], [ViewDescriptionAr], [ViewNameEn], [ViewNameAr], [ViewDB], [ViewSchema]) VALUES (1, N'Employee Information En', N'Employee Information Ar', N'EmployeeViewEn', N'EmployeeViewAr', N'IAS', N'dbgraph')
GO
INSERT [dbgraph].[ViewRegistry] ([ViewID], [ViewDescriptionEn], [ViewDescriptionAr], [ViewNameEn], [ViewNameAr], [ViewDB], [ViewSchema]) VALUES (2, N'Company InformationEn', N'Company Information Ar', N'CompanyViewEn', N'CompanyViewAr', N'IAS', N'dbgraph')
GO
INSERT [dbgraph].[ViewRegistry] ([ViewID], [ViewDescriptionEn], [ViewDescriptionAr], [ViewNameEn], [ViewNameAr], [ViewDB], [ViewSchema]) VALUES (3, N'Incidents', N'Incidents', N'DemoIncidentsViewEn', N'DemoIncidentsViewAr', N'IAS', N'dbgraph')
GO
SET IDENTITY_INSERT [dbgraph].[ViewRegistry] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ViewRegistry_Ar]    Script Date: 11/6/2025 4:59:19 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ViewRegistry_Ar] ON [dbgraph].[ViewRegistry]
(
	[ViewDB] ASC,
	[ViewSchema] ASC,
	[ViewNameAr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ViewRegistry_En]    Script Date: 11/6/2025 4:59:19 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ViewRegistry_En] ON [dbgraph].[ViewRegistry]
(
	[ViewDB] ASC,
	[ViewSchema] ASC,
	[ViewNameEn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbgraph].[SeedColumnCatalog] ADD  CONSTRAINT [DF_SeedCol_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbgraph].[SeedColumnCatalog] ADD  CONSTRAINT [DF_SeedCol_FirstSeen]  DEFAULT (sysutcdatetime()) FOR [FirstSeenAt]
GO
ALTER TABLE [dbgraph].[SeedColumnCatalog] ADD  CONSTRAINT [DF_SeedCol_LastSeen]  DEFAULT (sysutcdatetime()) FOR [LastSeenAt]
GO
ALTER TABLE [dbgraph].[ViewColumnMap]  WITH CHECK ADD  CONSTRAINT [FK_ViewColumnMap_ViewRegistry] FOREIGN KEY([ViewID])
REFERENCES [dbgraph].[ViewRegistry] ([ViewID])
ON DELETE CASCADE
GO
ALTER TABLE [dbgraph].[ViewColumnMap] CHECK CONSTRAINT [FK_ViewColumnMap_ViewRegistry]
GO
/****** Object:  StoredProcedure [dbgraph].[GetSeedColumns]    Script Date: 11/6/2025 4:59:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbgraph].[GetSeedColumns]
@ViewIDs dbgraph.IntList READONLY,
@Lang NVARCHAR(2) = N'en'
AS
BEGIN
SET NOCOUNT ON;

DECLARE @V TABLE(oid INT NOT NULL);
INSERT @V(oid)
SELECT OBJECT_ID(QUOTENAME(ViewDB)+N'.'+QUOTENAME(ViewSchema)+N'.'+QUOTENAME(ViewNameEn))
FROM dbgraph.ViewRegistry vr
WHERE EXISTS (SELECT 1 FROM @ViewIDs x WHERE x.id = vr.ViewID)
AND vr.ViewNameEn IS NOT NULL;

IF NOT EXISTS (SELECT 1 FROM @V)
BEGIN
SELECT CAST(NULL AS SYSNAME) AS Column_ID, CAST(NULL AS NVARCHAR(200)) AS DisplayName WHERE 1=0;
RETURN;
END

;WITH C AS (
SELECT DISTINCT c.name AS Column_ID
FROM @V v
JOIN sys.columns c ON c.object_id = v.oid
WHERE c.name LIKE N'ID[_]%' -- bracket escape, no ESCAPE clause needed
)
SELECT s.Column_ID,
DisplayName = CASE WHEN LOWER(@Lang) LIKE 'ar%'
THEN COALESCE(s.ColumnAr, s.ColumnEn, s.Column_ID)
ELSE COALESCE(s.ColumnEn, s.ColumnAr, s.Column_ID) END
FROM dbgraph.SeedColumnCatalog s
JOIN C ON C.Column_ID = s.Column_ID
WHERE s.IsActive = 1
ORDER BY DisplayName, s.Column_ID;
END
GO
/****** Object:  StoredProcedure [dbgraph].[GetSeedValues]    Script Date: 11/6/2025 4:59:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbgraph].[GetSeedValues]
  @Col      SYSNAME,                -- e.g., ID_CID  (pattern: ID_<group>ID)
  @Term     NVARCHAR(4000) = N'',   -- TEXT-only prefix filter (case-insensitive)
  @PageSize INT = 20,               -- first N items
  @ViewIDs  dbgraph.IntList READONLY,
  @Lang     NVARCHAR(2) = N'en'
AS
BEGIN
  SET NOCOUNT ON;

  IF @PageSize IS NULL OR @PageSize < 1 SET @PageSize = 20;
  IF @PageSize > 200 SET @PageSize = 200;

  -- Resolve selected views using English physical names
  DECLARE @V TABLE(db SYSNAME, sch SYSNAME, vw SYSNAME, oid INT);
  INSERT @V(db, sch, vw, oid)
  SELECT vr.ViewDB, vr.ViewSchema, vr.ViewNameEn,
         OBJECT_ID(QUOTENAME(vr.ViewDB)+N'.'+QUOTENAME(vr.ViewSchema)+N'.'+QUOTENAME(vr.ViewNameEn))
  FROM dbgraph.ViewRegistry vr
  WHERE EXISTS (SELECT 1 FROM @ViewIDs x WHERE x.id = vr.ViewID)
    AND vr.ViewNameEn IS NOT NULL;

  IF NOT EXISTS (SELECT 1 FROM @V)
  BEGIN
    SELECT CAST(NULL AS NVARCHAR(4000)) AS val, CAST(NULL AS NVARCHAR(4000)) AS label WHERE 1=0;
    RETURN;
  END

  -- Ensure ID column exists in at least one selected view
  IF NOT EXISTS (
      SELECT 1 FROM @V v JOIN sys.columns c ON c.object_id = v.oid
      WHERE c.name = @Col
  )
  BEGIN
    RAISERROR('Unknown or disallowed column: %s', 16, 1, @Col);
    RETURN;
  END

  -- Extract <group> and build label column: TEXT_<group>TEXT
  DECLARE @grp SYSNAME = @Col;

  -- Strip leading 'ID_'
  IF LEFT(@grp, 3) = N'ID_'
    SET @grp = SUBSTRING(@grp, 4, LEN(@grp));

  -- Strip trailing '_ID' first; else strip trailing 'ID'
  IF RIGHT(@grp, 3) = N'_ID'
    SET @grp = LEFT(@grp, LEN(@grp) - 3);
  ELSE IF RIGHT(@grp, 2) = N'ID'
    SET @grp = LEFT(@grp, LEN(@grp) - 2);

  DECLARE @LabelCol SYSNAME = N'TEXT_' + @grp + N'TEXT';

  -- Keep only views that have BOTH the ID column and the exact TEXT_<group>TEXT column
  CREATE TABLE #S (db SYSNAME, sch SYSNAME, vw SYSNAME);
  INSERT #S(db, sch, vw)
  SELECT v.db, v.sch, v.vw
  FROM @V v
  WHERE EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = v.oid AND c.name = @Col)
    AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = v.oid AND c.name = @LabelCol);

  IF NOT EXISTS (SELECT 1 FROM #S)
  BEGIN
    SELECT CAST(NULL AS NVARCHAR(4000)) AS val, CAST(NULL AS NVARCHAR(4000)) AS label WHERE 1=0;
    RETURN;
  END

  -- Build union across qualifying views; TEXT-only prefix filter (case-insensitive, accent-insensitive)
  DECLARE @sql NVARCHAR(MAX) =
    (SELECT STRING_AGG(CAST(
        N'SELECT DISTINCT ' +
        N'  CONVERT(NVARCHAR(4000), t.' + QUOTENAME(@Col)      + N') AS val, ' +
        N'  CONVERT(NVARCHAR(4000), t.' + QUOTENAME(@LabelCol) + N') AS label ' +
        N'FROM ' + QUOTENAME(s.db) + N'.' + QUOTENAME(s.sch) + N'.' + QUOTENAME(s.vw) + N' AS t ' +
        N'WHERE (@Term = N'''' OR CONVERT(NVARCHAR(4000), t.' + QUOTENAME(@LabelCol) + N') COLLATE Latin1_General_CI_AI LIKE @Term + N''%'' )'
      AS NVARCHAR(MAX)), N' UNION ALL ')
     FROM #S s);

  DECLARE @final NVARCHAR(MAX) = N'
    WITH U AS (' + @sql + N')
    SELECT TOP (@Lim)
           MIN(val) AS val,  -- representative ID for each label
           label
    FROM U
    WHERE label IS NOT NULL AND label <> N''''
    GROUP BY label
    ORDER BY label;';

  EXEC sp_executesql @final,
                     N'@Term NVARCHAR(4000), @Lim INT',
                     @Term = @Term, @Lim = @PageSize;
END
GO
/****** Object:  StoredProcedure [dbgraph].[SeedColumns_SyncCatalog]    Script Date: 11/6/2025 4:59:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbgraph].[SeedColumns_SyncCatalog]
  @PruneMissing BIT = 1     -- 1 = hard delete rows no longer present in any registered view
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRAN;

    DECLARE @V TABLE(oid INT NOT NULL);
    INSERT @V(oid)
    SELECT OBJECT_ID(QUOTENAME(ViewDB)+N'.'+QUOTENAME(ViewSchema)+N'.'+QUOTENAME(ViewNameEn))
    FROM dbgraph.ViewRegistry
    WHERE ViewNameEn IS NOT NULL;

    ;WITH C AS (
      SELECT DISTINCT c.name AS Column_ID
      FROM @V v
      JOIN sys.columns c ON c.object_id = v.oid
      WHERE c.name LIKE N'ID\_%' ESCAPE N'\'
    )
    SELECT Column_ID INTO #All FROM C;

    -- Insert new ID_ columns
    INSERT INTO dbgraph.SeedColumnCatalog (Column_ID)
    SELECT a.Column_ID
    FROM #All a
    LEFT JOIN dbgraph.SeedColumnCatalog s ON s.Column_ID = a.Column_ID
    WHERE s.Column_ID IS NULL;

    -- Touch LastSeenAt for all seen this run
    UPDATE s
    SET LastSeenAt = SYSUTCDATETIME()
    FROM dbgraph.SeedColumnCatalog s
    JOIN #All a ON a.Column_ID = s.Column_ID;

    -- Hard delete missing, if requested
    IF @PruneMissing = 1
    BEGIN
      DELETE s
      FROM dbgraph.SeedColumnCatalog s
      LEFT JOIN #All a ON a.Column_ID = s.Column_ID
      WHERE a.Column_ID IS NULL;
    END

    COMMIT;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@msg, 16, 1);
  END CATCH
END;
GO
/****** Object:  StoredProcedure [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang]    Script Date: 11/6/2025 4:59:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Re-alter [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang] with clean dynamic SQL */
CREATE PROCEDURE [dbgraph].[TraverseStep_FromRegisteredView_FastCore_Lang]
(
    @ViewID              INT,
    @Frontier            dbgraph.ColValPair READONLY,
    @Depth               INT,
    @ExcludeForThisView  dbgraph.ColValPair READONLY,
    @Lang                NVARCHAR(2) = N'en',
    @MaxFanout           INT = NULL,
    @ReturnMode          NVARCHAR(8) = N'EDGES'
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @db SYSNAME, @sch SYSNAME, @vw SYSNAME;
    SELECT
        @db  = ViewDB,
        @sch = ViewSchema,
        @vw  = CASE WHEN @Lang = N'ar' THEN ViewNameAr ELSE ViewNameEn END
    FROM dbgraph.ViewRegistry
    WHERE ViewID = @ViewID;

    IF @db IS NULL OR @sch IS NULL OR @vw IS NULL
    BEGIN RAISERROR('dbgraph: ViewID %d not found or language mapping missing.',16,1,@ViewID); RETURN; END;

    DECLARE @three NVARCHAR(512) = QUOTENAME(@db)+N'.'+QUOTENAME(@sch)+N'.'+QUOTENAME(@vw);

    IF OBJECT_ID('tempdb..#F') IS NOT NULL DROP TABLE #F;
    CREATE TABLE #F
    (
        col  SYSNAME NOT NULL,
        val  NVARCHAR(4000) NOT NULL,
        val_hash AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), val)))
    );
    CREATE UNIQUE NONCLUSTERED INDEX UX_F ON #F(col, val_hash) INCLUDE (val);
    INSERT #F(col,val)
    SELECT col, LTRIM(RTRIM(val))
    FROM @Frontier
    WHERE val IS NOT NULL
    GROUP BY col, LTRIM(RTRIM(val));

    IF OBJECT_ID('tempdb..#X') IS NOT NULL DROP TABLE #X;
    CREATE TABLE #X
    (
        col  SYSNAME NOT NULL,
        val  NVARCHAR(4000) NOT NULL,
        val_hash AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), val)))
    );
    CREATE UNIQUE NONCLUSTERED INDEX UX_X ON #X(col, val_hash) INCLUDE (val);
    INSERT #X(col,val)
    SELECT col, LTRIM(RTRIM(val))
    FROM @ExcludeForThisView
    WHERE val IS NOT NULL
    GROUP BY col, LTRIM(RTRIM(val));

    IF OBJECT_ID('tempdb..#Pairs') IS NOT NULL DROP TABLE #Pairs;
    CREATE TABLE #Pairs
    (
        grp       NVARCHAR(128) PRIMARY KEY,
        id_col    SYSNAME NOT NULL,
        text_col  SYSNAME NOT NULL,
        color_col SYSNAME NOT NULL,
        nt_col    SYSNAME NOT NULL
    );

    DECLARE @objId INT = OBJECT_ID(@three);
    IF @objId IS NULL BEGIN RAISERROR('dbgraph: View not found: %s',16,1,@three); RETURN; END;

    ;WITH C AS (SELECT name FROM sys.columns WHERE object_id=@objId),
    NT AS (SELECT SUBSTRING(name,4,4000) grp, name nt_col FROM C WHERE name LIKE N'NT\_%' ESCAPE '\'),
    ID AS (SELECT LEFT(SUBSTRING(name,4,4000), LEN(SUBSTRING(name,4,4000))-2) grp, name id_col
           FROM C WHERE name LIKE N'ID\_%' ESCAPE '\' AND RIGHT(name,2)='ID'),
    TX AS (SELECT LEFT(SUBSTRING(name,6,4000), LEN(SUBSTRING(name,6,4000))-4) grp, name text_col
           FROM C WHERE name LIKE N'TEXT\_%' ESCAPE '\' AND RIGHT(name,4)='TEXT'),
    CL AS (SELECT SUBSTRING(name,7,4000) grp, name color_col FROM C WHERE name LIKE N'COLOR\_%' ESCAPE '\')
    INSERT #Pairs(grp, id_col, text_col, color_col, nt_col)
    SELECT N.grp, I.id_col, T.text_col, L.color_col, N.nt_col
    FROM NT N JOIN ID I ON I.grp=N.grp JOIN TX T ON T.grp=N.grp JOIN CL L ON L.grp=N.grp;

    IF NOT EXISTS (SELECT 1 FROM #Pairs)
    BEGIN RAISERROR('dbgraph: No NT/ID/TEXT/COLOR groups in %s',16,1,@three); RETURN; END

    DECLARE @Base NVARCHAR(MAX) =
    (
        SELECT STRING_AGG(
          CAST(
          N'SELECT t.*, '
          + N'''' + p.id_col + N''' AS cur_id_col, '
          + N'CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), t.' + QUOTENAME(p.id_col) + N'))) AS cur_id_hash '
          + N'FROM ' + @three + N' AS t '
          + N'WHERE EXISTS ( '
          + N'  SELECT 1 FROM #F f '
          + N'  WHERE f.col = ''' + p.id_col + N''' '
          + N'    AND f.val_hash = CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), t.' + QUOTENAME(p.id_col) + N'))) '
          + N')'
          AS NVARCHAR(MAX)),
          N' UNION ALL '
        )
        FROM #Pairs p
        WHERE EXISTS (SELECT 1 FROM #F WHERE col = p.id_col)
    );
    IF @Base IS NULL
        SET @Base = N'SELECT t.*, CAST(NULL AS SYSNAME) cur_id_col, CAST(NULL AS VARBINARY(32)) cur_id_hash FROM ' + @three + N' t WHERE 1=0';

    DECLARE @CurUnion NVARCHAR(MAX) =
    (
      SELECT STRING_AGG(
        CAST(
        N'SELECT '
        + N'''' + p.id_col + N''' AS cur_col, '
        + N'CONVERT(NVARCHAR(4000), t.' + QUOTENAME(p.id_col) + N') AS cur_val, '
        + N't.' + QUOTENAME(p.text_col)  + N' AS cur_text, '
        + N't.' + QUOTENAME(p.color_col) + N' AS cur_color, '
        + N't.' + QUOTENAME(p.nt_col)    + N' AS cur_type, '
        + N't.row_id AS row_id '
        + N'FROM Base t'
        AS NVARCHAR(MAX)),
        N' UNION ALL '
      )
      FROM #Pairs p
    );
    DECLARE @NxtUnion NVARCHAR(MAX) = @CurUnion;

    DECLARE @sqlCte NVARCHAR(MAX) = N'
WITH Base0 AS ( ' + @Base + N' ),
Base AS (
  SELECT Base0.*, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS row_id
  FROM Base0
),
Cur AS ( ' + @CurUnion + N' ),
Fanout AS (
  SELECT
    c.cur_col, c.cur_val,
    c.cur_text, c.cur_color, c.cur_type,
    n.cur_col AS nxt_col, n.cur_val AS nxt_val,
    n.cur_text AS nxt_text, n.cur_color AS nxt_color, n.cur_type AS nxt_type,
    ROW_NUMBER() OVER (PARTITION BY c.cur_col, c.cur_val ORDER BY n.cur_col, n.cur_val) AS rn
  FROM Cur c
  JOIN Base b
    ON b.cur_id_col = c.cur_col
   AND b.cur_id_hash = CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), c.cur_val)))
   AND b.row_id = c.row_id
  JOIN (' + @NxtUnion + N') n
    ON n.row_id = b.row_id
  WHERE n.cur_val IS NOT NULL
    AND NOT (n.cur_col = c.cur_col AND ISNULL(n.cur_val, '''') = ISNULL(c.cur_val, ''''))
),
Pruned AS (
  SELECT *
  FROM Fanout
  WHERE (@MaxFanout IS NULL OR rn <= @MaxFanout)
    AND NOT EXISTS (
      SELECT 1 FROM #X x
      WHERE x.col = nxt_col
        AND x.val_hash = CONVERT(VARBINARY(32), HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(4000), nxt_val)))
    )
),
Agg AS (
  SELECT
    cur_col, cur_val, nxt_col, nxt_val,
    MIN(cur_type)  AS cur_type,
    MIN(cur_text)  AS cur_text,
    MIN(cur_color) AS cur_color,
    MIN(nxt_type)  AS nxt_type,
    MIN(nxt_text)  AS nxt_text,
    MIN(nxt_color) AS nxt_color
  FROM Pruned
  GROUP BY cur_col, cur_val, nxt_col, nxt_val
)
';

    DECLARE @sql NVARCHAR(MAX);
    IF @ReturnMode = N'NEXT'
        SET @sql = @sqlCte + N'
SELECT DISTINCT col = nxt_col, val = nxt_val
FROM Agg
ORDER BY col, val
OPTION (RECOMPILE);';
    ELSE
        SET @sql = @sqlCte + N'
SELECT
  view_id    = @ViewID,
  depth      = @Depth,
  from_col   = cur_col,
  from_val   = cur_val,
  from_type  = cur_type,
  from_text  = cur_text,
  from_color = cur_color,
  to_col     = nxt_col,
  to_val     = nxt_val,
  to_type    = nxt_type,
  to_text    = nxt_text,
  to_color   = nxt_color,
  path       = CONCAT(cur_col, N''='', cur_val, N'' -> '', nxt_col, N''='', nxt_val)
FROM Agg
ORDER BY from_col, from_val, to_col, to_val
OPTION (RECOMPILE);';

    EXEC sp_executesql
      @sql,
      N'@ViewID int, @Depth int, @MaxFanout int',
      @ViewID=@ViewID, @Depth=@Depth, @MaxFanout=@MaxFanout;
END
GO
/****** Object:  StoredProcedure [dbgraph].[TraverseStep_MultiViews_PerViewExclude_Lang]    Script Date: 11/6/2025 4:59:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* [dbgraph].[TraverseStep_MultiViews_PerViewExclude_Lang] */
CREATE PROCEDURE [dbgraph].[TraverseStep_MultiViews_PerViewExclude_Lang]
(
    @ViewIDs        dbgraph.IntList READONLY,
    @Frontier       dbgraph.ColValPair READONLY,
    @PerViewExclude dbgraph.ViewColValPair READONLY,
    @Depth          INT,
    @Lang           NVARCHAR(2) = N'en',
    @MaxFanout      INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#Edges') IS NOT NULL DROP TABLE #Edges;
    CREATE TABLE #Edges
    (
        view_id   INT NOT NULL,
        depth     INT NOT NULL,
        from_col  SYSNAME NOT NULL,
        from_val  NVARCHAR(4000) NOT NULL,
        from_type NVARCHAR(4000) NULL,
        from_text NVARCHAR(MAX)  NULL,
        from_color NVARCHAR(100) NULL,
        to_col    SYSNAME NOT NULL,
        to_val    NVARCHAR(4000) NOT NULL,
        to_type   NVARCHAR(4000) NULL,
        to_text   NVARCHAR(MAX)  NULL,
        to_color  NVARCHAR(100)  NULL,
        path      NVARCHAR(MAX)  NULL,
        from_val_hash AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), from_val))),
        to_val_hash   AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), to_val)))
    );

    CREATE UNIQUE NONCLUSTERED INDEX UX_E
      ON #Edges(view_id, from_col, to_col, from_val_hash, to_val_hash)
      INCLUDE (from_val, to_val)
      WITH (IGNORE_DUP_KEY = ON);

    IF OBJECT_ID('tempdb..#Next') IS NOT NULL DROP TABLE #Next;
    CREATE TABLE #Next
    (
        col SYSNAME NOT NULL,
        val NVARCHAR(4000) NOT NULL,
        val_hash AS CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONVERT(NVARCHAR(4000), val)))
    );

    CREATE UNIQUE NONCLUSTERED INDEX UX_N
      ON #Next(col, val_hash)
      INCLUDE (val)
      WITH (IGNORE_DUP_KEY = ON);

    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT id FROM @ViewIDs;
    DECLARE @vid INT; OPEN cur; FETCH NEXT FROM cur INTO @vid;

    DECLARE @X dbgraph.ColValPair;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM @X;

        INSERT @X(col, val)
        SELECT  col,
                LTRIM(RTRIM(val))
        FROM @PerViewExclude
        WHERE ViewID = @vid
          AND val IS NOT NULL
        GROUP BY col, LTRIM(RTRIM(val));

        INSERT #Edges
            (view_id, depth, from_col, from_val, from_type, from_text, from_color,
             to_col,   to_val,   to_type,   to_text,   to_color,   path)
        EXEC dbgraph.TraverseStep_FromRegisteredView_FastCore_Lang
             @ViewID=@vid, @Frontier=@Frontier, @Depth=@Depth,
             @ExcludeForThisView=@X, @Lang=@Lang, @MaxFanout=@MaxFanout, @ReturnMode=N'EDGES';

        INSERT #Next(col, val)
        EXEC dbgraph.TraverseStep_FromRegisteredView_FastCore_Lang
             @ViewID=@vid, @Frontier=@Frontier, @Depth=@Depth,
             @ExcludeForThisView=@X, @Lang=@Lang, @MaxFanout=@MaxFanout, @ReturnMode=N'NEXT';

        FETCH NEXT FROM cur INTO @vid;
    END
    CLOSE cur; DEALLOCATE cur;

    SELECT
      from_col, from_val,
      from_type  = MIN(from_type),
      from_text  = MIN(from_text),
      from_color = MIN(from_color),
      to_col, to_val,
      to_type    = MIN(to_type),
      to_text    = MIN(to_text),
      to_color   = MIN(to_color),
      views_count = COUNT(DISTINCT view_id),
      views_list  = STRING_AGG(CAST(view_id AS NVARCHAR(MAX)), ',') WITHIN GROUP (ORDER BY view_id)
    FROM #Edges
    GROUP BY from_col, from_val, to_col, to_val
    ORDER BY from_col, from_val, to_col, to_val;

    SELECT col, val FROM #Next ORDER BY col, val;
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DemoIncidents"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbgraph', @level1type=N'VIEW',@level1name=N'DemoIncidentsViewEn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbgraph', @level1type=N'VIEW',@level1name=N'DemoIncidentsViewEn'
GO
USE [master]
GO
ALTER DATABASE [IAS] SET  READ_WRITE 
GO

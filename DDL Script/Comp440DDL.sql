USE [master]
GO
/****** Object:  Database [s16guest52]    Script Date: 5/2/2016 7:32:31 PM ******/
CREATE DATABASE [s16guest52]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N's16guest52', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.CSDB440\MSSQL\DATA\s16guest52.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N's16guest52_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.CSDB440\MSSQL\DATA\s16guest52_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [s16guest52] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [s16guest52].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [s16guest52] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [s16guest52] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [s16guest52] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [s16guest52] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [s16guest52] SET ARITHABORT OFF 
GO
ALTER DATABASE [s16guest52] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [s16guest52] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [s16guest52] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [s16guest52] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [s16guest52] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [s16guest52] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [s16guest52] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [s16guest52] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [s16guest52] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [s16guest52] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [s16guest52] SET  ENABLE_BROKER 
GO
ALTER DATABASE [s16guest52] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [s16guest52] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [s16guest52] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [s16guest52] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [s16guest52] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [s16guest52] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [s16guest52] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [s16guest52] SET RECOVERY FULL 
GO
ALTER DATABASE [s16guest52] SET  MULTI_USER 
GO
ALTER DATABASE [s16guest52] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [s16guest52] SET DB_CHAINING OFF 
GO
ALTER DATABASE [s16guest52] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [s16guest52] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N's16guest52', N'ON'
GO
USE [s16guest52]
GO
/****** Object:  User [s16guest52]    Script Date: 5/2/2016 7:32:32 PM ******/
CREATE USER [s16guest52] FOR LOGIN [s16guest52] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [s16guest52]
GO
/****** Object:  StoredProcedure [dbo].[CityExists]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CityExists]
	-- Add the parameters for the stored procedure here
	@City varchar(30)
AS
DECLARE @err_message varchar(100)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (Select CityName from City where CityName = @City)
		BEGIN
		select * from City where CityName = @City
		END
	ELSE
		BEGIN
		SET @err_message = @City + ' Not found in City Database'
				 RAISERROR (@err_message,10, 1) 	
		END

END

GO
/****** Object:  StoredProcedure [dbo].[CountDownloadByMonth]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CountDownloadByMonth]
	-- Add the parameters for the stored procedure here
	@Version varchar(10),
	@Month varchar(10),
	@Product varchar(30)
AS
DECLARE @err_message varchar(100)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (Select ProductName from Product WHERE ProductName = @Product)
		BEGIN
		DECLARE @ProductID int
		SET @ProductID = (Select ProductID from Product where ProductName = @Product)
		END
	ELSE
		BEGIN
		SET @err_message = ('Product does not exist does not exist in our Database')
		RAISERROR (@err_message,10, 1)
		END

	IF EXISTS (Select VersionID from Version WHERE @ProductID = @ProductID AND VersionNumber = @Version)
		BEGIN
		DECLARE @VersionID int
		SET @VersionID = (Select VersionID from Version where @ProductID = @ProductID AND VersionNumber = @Version)
		END
	ELSE
		BEGIN
		SET @err_message = ('Version does not exist does not exist in our Database')
		RAISERROR (@err_message,10, 1)
		END

	IF EXISTS (Select ReleaseID from CustomerRelease WHERE VersionID = @VersionID)
		BEGIN
			DECLARE @ReleaseID int
			SET @ReleaseID = (Select ReleaseID from CustomerRelease WHERE VersionID = @VersionID)
		END
	ELSE
		BEGIN
		SET @err_message = ('Customer Release does not exist does not exist in our Database')
				 RAISERROR (@err_message,10, 1) 	
		END

	IF EXISTS (Select ReleaseID from Download WHERE ReleaseID = @ReleaseID AND DownloadDate LIKE @Month+'%')
		BEGIN
			SELECT COUNT(ReleaseID) FROM Download WHERE ReleaseID = @ReleaseID AND DownloadDate LIKE @Month+'%'
		END
	ELSE
		BEGIN
		SET @err_message = ('No downloads this month')
		--SET @err_message = (@Month)
				 RAISERROR (@err_message,10, 1) 	
		END

END
GO
/****** Object:  StoredProcedure [dbo].[CountNewFeatures]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CountNewFeatures]
	-- Add the parameters for the stored procedure here
	@Version varchar(10),
	@Product varchar(30)

AS
BEGIN
	DECLARE @err_message varchar(100)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	IF EXISTS (Select ProductID from Product where ProductName = @Product)
		BEGIN
		DECLARE @ProductID int
		SET @ProductID = (Select ProductID from Product where ProductName = @Product)
		END
	ELSE
		BEGIN
		SET @err_message = 'Product does not exist'
		RAISERROR (@err_message,10, 1) 	
		END

	IF EXISTS (Select VersionID from Version where VersionNumber = @Version AND ProductID = @ProductID)
		BEGIN
		DECLARE @VersionID int
		SET @VersionID = (Select VersionID from Version where VersionNumber = @Version AND ProductID = @ProductID)
		END
	ELSE
		BEGIN
		SET @err_message = 'Version does not exist'
		RAISERROR (@err_message,10, 1) 	
		END

	IF EXISTS (Select FeatureID from Feature where VersionID = @VersionID)
		BEGIN
				IF EXISTS(Select FeatureID from Feature where VersionID = @VersionID AND Type like '%new%')
				BEGIN 
				DECLARE @Count int
				SET @Count = (Select COUNT(FeatureID) from Feature where VersionID = @VersionID AND Type like '%new%')
				PRINT str(@count) + ' features are in the ' + @Version + ' release'
				END
			ELSE
				BEGIN
				PRINT 'It is a bug –fix release. There are no new features'
				END
		END
	ELSE
		BEGIN
		SET @err_message = 'No new features'
		RAISERROR (@err_message,10, 1) 	
		END
END
GO
/****** Object:  StoredProcedure [dbo].[CountProductDownloads]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CountProductDownloads]
	-- Add the parameters for the stored procedure here
	@ReleaseID int

AS
DECLARE @err_message varchar(100)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (Select ReleaseID from Download WHERE ReleaseID = @ReleaseID)
		BEGIN
		SELECT COUNT(ReleaseID) FROM Download WHERE ReleaseID = @ReleaseID;
		END
	ELSE
		BEGIN
		SET @err_message = ('Product does not exist does not exist in our Database')
				 RAISERROR (@err_message,10, 1) 	
		END
END
GO
/****** Object:  StoredProcedure [dbo].[InsertCity]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertCity]
	-- Add the parameters for the stored procedure here
	@City varchar(30)
AS
BEGIN
	DECLARE @err_message varchar(100)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	IF EXISTS (Select CityName from City where CityName = @City)
		BEGIN
		SET @err_message = @City + ' alredy exists.'
		RAISERROR (@err_message,10, 1) 	
		END
	ELSE
		BEGIN
		INSERT INTO City
		VALUES	(@City);	
		END

END

GO
/****** Object:  StoredProcedure [dbo].[InsertCountry]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertCountry]
	-- Add the parameters for the stored procedure here
	@Country varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	BEGIN TRY
		INSERT INTO COUNTRY
		VALUES (@Country)
	END TRY
	BEGIN CATCH
		RAISERROR('Country could not be created', 16, 1)
	END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[InsertState]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertState]
	-- Add the parameters for the stored procedure here
	@State varchar(30),
	@Abbreviation char(2)
AS

BEGIN
	DECLARE @err_message varchar(100)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	IF EXISTS (Select StateName from State where StateName = @State)
		BEGIN
		SET @err_message = @State + ' alredy exists.'
		RAISERROR (@err_message,10, 1) 	
		END
	ELSE
		BEGIN
		INSERT INTO State
		VALUES	(@State, @Abbreviation);	
		END
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateVersion]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateVersion]
	-- Add the parameters for the stored procedure here.
	@ProductID int,
	@VersionNumber varchar(10),
	@ReleaseDate varchar(10),
	@updateNumber varchar(10)
AS
DECLARE @err_message varchar(100)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (Select * from Version where ProductID = @ProductID AND VersionNumber = @VersionNumber)
		BEGIN
		UPDATE Version
		SET ReleaseDate = @ReleaseDate, VersionNumber = @updateNumber
		WHERE VersionNumber = @VersionNumber;
		END
	ELSE
		BEGIN
		SET @err_message = (@VersionNumber + ' Or Product does not exist does not exist in Version Database')
				 RAISERROR (@err_message,10, 1) 	
		END
END

GO
/****** Object:  Table [dbo].[Address]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[Street] [varchar](50) NULL,
	[Zip] [int] NULL,
	[CityID] [int] NULL,
	[StateID] [int] NULL,
	[CountryID] [int] NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Branch](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[SprintID] [int] NOT NULL,
	[BranchName] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[City]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[City](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[CityName] [varchar](30) NOT NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Commit]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Commit](
	[CommitID] [int] IDENTITY(1,1) NOT NULL,
	[CommitMessege] [char](100) NULL,
	[BranchID] [int] NOT NULL,
 CONSTRAINT [PK_Commit] PRIMARY KEY CLUSTERED 
(
	[CommitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Company]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[AddressID] [int] NULL,
	[CompanyName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](30) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[FirstName] [char](30) NULL,
	[LastName] [char](30) NOT NULL,
	[Email] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerRelease]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerRelease](
	[ReleaseID] [int] IDENTITY(1,1) NOT NULL,
	[VersionID] [int] NOT NULL,
	[DownloadLink] [varchar](50) NOT NULL,
	[ReleaseDate] [varchar](10) NOT NULL,
 CONSTRAINT [PK_CustomerRelease] PRIMARY KEY CLUSTERED 
(
	[ReleaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Download]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Download](
	[CustomerID] [int] NOT NULL,
	[ReleaseID] [int] NOT NULL,
	[DownloadDate] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Download_1] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC,
	[ReleaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Feature]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Feature](
	[FeatureID] [int] IDENTITY(1,1) NOT NULL,
	[VersionID] [int] NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Platform] [char](10) NOT NULL,
 CONSTRAINT [PK_Feature] PRIMARY KEY CLUSTERED 
(
	[FeatureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Phone]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Phone](
	[PhoneID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Type] [char](10) NULL,
	[PhoneNumber] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Phone] PRIMARY KEY CLUSTERED 
(
	[PhoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](30) NOT NULL,
	[ProductDescription] [varchar](255) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sprints]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sprints](
	[SprintID] [int] IDENTITY(1,1) NOT NULL,
	[VersionId] [int] NOT NULL,
	[SprintNumber] [int] NOT NULL,
	[StartDate] [varchar](10) NULL,
	[EndDate] [varchar](10) NULL,
 CONSTRAINT [PK_Sprints] PRIMARY KEY CLUSTERED 
(
	[SprintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[State]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[State](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [varchar](30) NOT NULL,
	[Abbreviation] [char](2) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Version]    Script Date: 5/2/2016 7:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Version](
	[VersionID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ReleaseDate] [varchar](10) NULL,
	[VersionNumber] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Version_1] PRIMARY KEY CLUSTERED 
(
	[VersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_City] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_City]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_Country]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_AddressID_State] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([StateID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_AddressID_State]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_AddressID_State1] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([StateID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_AddressID_State1]
GO
ALTER TABLE [dbo].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Sprints] FOREIGN KEY([SprintID])
REFERENCES [dbo].[Sprints] ([SprintID])
GO
ALTER TABLE [dbo].[Branch] CHECK CONSTRAINT [FK_Branch_Sprints]
GO
ALTER TABLE [dbo].[Commit]  WITH CHECK ADD  CONSTRAINT [FK_Commit_Branch1] FOREIGN KEY([BranchID])
REFERENCES [dbo].[Branch] ([BranchID])
GO
ALTER TABLE [dbo].[Commit] CHECK CONSTRAINT [FK_Commit_Branch1]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_Address]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Company] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Company] ([CompanyID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Company]
GO
ALTER TABLE [dbo].[CustomerRelease]  WITH CHECK ADD  CONSTRAINT [FK_CustomerRelease_Version1] FOREIGN KEY([VersionID])
REFERENCES [dbo].[Version] ([VersionID])
GO
ALTER TABLE [dbo].[CustomerRelease] CHECK CONSTRAINT [FK_CustomerRelease_Version1]
GO
ALTER TABLE [dbo].[Download]  WITH CHECK ADD  CONSTRAINT [FK_Download_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Download] CHECK CONSTRAINT [FK_Download_Customer]
GO
ALTER TABLE [dbo].[Download]  WITH CHECK ADD  CONSTRAINT [FK_Download_CustomerRelease] FOREIGN KEY([ReleaseID])
REFERENCES [dbo].[CustomerRelease] ([ReleaseID])
GO
ALTER TABLE [dbo].[Download] CHECK CONSTRAINT [FK_Download_CustomerRelease]
GO
ALTER TABLE [dbo].[Feature]  WITH CHECK ADD  CONSTRAINT [FK_Feature_Version] FOREIGN KEY([VersionID])
REFERENCES [dbo].[Version] ([VersionID])
GO
ALTER TABLE [dbo].[Feature] CHECK CONSTRAINT [FK_Feature_Version]
GO
ALTER TABLE [dbo].[Phone]  WITH CHECK ADD  CONSTRAINT [FK_Phone_Customer1] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Phone] CHECK CONSTRAINT [FK_Phone_Customer1]
GO
ALTER TABLE [dbo].[Sprints]  WITH CHECK ADD  CONSTRAINT [FK_Sprints_Version] FOREIGN KEY([SprintNumber])
REFERENCES [dbo].[Version] ([VersionID])
GO
ALTER TABLE [dbo].[Sprints] CHECK CONSTRAINT [FK_Sprints_Version]
GO
ALTER TABLE [dbo].[Version]  WITH CHECK ADD  CONSTRAINT [FK_Version_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Version] CHECK CONSTRAINT [FK_Version_Product]
GO
USE [master]
GO
ALTER DATABASE [s16guest52] SET  READ_WRITE 
GO

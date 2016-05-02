/****** Object:  StoredProcedure [dbo].[CountDownloadByMonth]    Script Date: 5/2/2016 4:32:42 PM ******/
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
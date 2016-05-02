/****** Object:  StoredProcedure [dbo].[CountProductDownloads]    Script Date: 5/2/2016 4:32:42 PM ******/
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
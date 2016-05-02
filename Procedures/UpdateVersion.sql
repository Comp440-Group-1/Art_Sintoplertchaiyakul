/****** Object:  StoredProcedure [dbo].[UpdateVersion]    Script Date: 5/2/2016 4:32:42 PM ******/
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
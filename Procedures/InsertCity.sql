/****** Object:  StoredProcedure [dbo].[InsertCity]    Script Date: 5/2/2016 4:32:42 PM ******/
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
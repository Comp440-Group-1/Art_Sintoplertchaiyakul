/****** Object:  StoredProcedure [dbo].[InsertCountry]    Script Date: 5/2/2016 4:32:42 PM ******/
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
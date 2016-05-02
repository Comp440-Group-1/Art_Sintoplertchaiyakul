/****** Object:  StoredProcedure [dbo].[InsertState]    Script Date: 5/2/2016 4:32:42 PM ******/
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
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
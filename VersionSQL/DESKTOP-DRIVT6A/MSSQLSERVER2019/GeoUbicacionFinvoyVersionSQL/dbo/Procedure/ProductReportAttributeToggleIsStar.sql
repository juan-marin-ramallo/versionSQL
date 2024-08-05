/****** Object:  Procedure [dbo].[ProductReportAttributeToggleIsStar]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductReportAttributeToggleIsStar]
	 @IdAttribute int
	,@MarkAsStar bit
AS
BEGIN
	
	DECLARE @Success bit = 0

	IF @MarkAsStar = 0
	BEGIN
	
		UPDATE ProductReportAttribute
		SET [IsStar] = 0
		WHERE [Id] = @IdAttribute
	
		SET @Success = 1

	END ELSE BEGIN

		DECLARE @MaxStarAttributes int = 2
		IF (SELECT COUNT(1) 
			FROM ProductReportAttribute 
			WHERE [IsStar] = 1
			  AND [Deleted] = 0
			  AND [FullDeleted] = 0) < @MaxStarAttributes
		BEGIN 
			
			UPDATE ProductReportAttribute
			SET [IsStar] = 1
			WHERE [Id] = @IdAttribute
			
			SET @Success = 1
				
		END
	END

	IF @Success = 1 BEGIN
		EXEC [dbo].[UpdateAllProductPointOfInterestChangeLog]
	END

	SELECT @Success

END

/****** Object:  Procedure [dbo].[UpdateCustomAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCustomAttributeValue]
	 @IdCustomAttribute int
	,@IdPointOfInterest int
	,@Value varchar(MAX) = NULL
	,@IdCustomAttributeOption int = null
AS
BEGIN

	DECLARE @IdCustomAttributeValue int = 
		(SELECT Id 
		 FROM CustomAttributeValue 
		 WHERE IdPointOfInterest = @IdPointOfInterest
		   AND IdCustomAttribute = @IdCustomAttribute)

	IF (@IdCustomAttributeValue IS NOT NULL) BEGIN
		IF (@Value IS NOT NULL OR @IdCustomAttributeOption IS NOT NULL) BEGIN -- Si hay datos update
			UPDATE CustomAttributeValue
			SET [Value] = IIF(@IdCustomAttributeOption IS NULL, @Value, NULL),
				[IdCustomAttributeOption] = @IdCustomAttributeOption
			WHERE [Id] = @IdCustomAttributeValue
		END ELSE BEGIN -- Si no, borro el attr value
			DELETE FROM CustomAttributeValue
			WHERE [Id] = @IdCustomAttributeValue
		END
	END ELSE BEGIN
		IF (@Value IS NOT NULL OR @IdCustomAttributeOption IS NOT NULL) BEGIN
			INSERT INTO CustomAttributeValue ([IdCustomAttribute], [IdPointOfInterest], [Value], [IdCustomAttributeOption])
			VALUES (@IdCustomAttribute, @IdPointOfInterest, IIF(@IdCustomAttributeOption IS NULL, @Value, NULL), @IdCustomAttributeOption)
		END
	END
END

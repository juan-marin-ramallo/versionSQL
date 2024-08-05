/****** Object:  Procedure [dbo].[DeletePersonOfInterestType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para eliminar un repositor
-- =============================================
CREATE PROCEDURE [dbo].[DeletePersonOfInterestType]
(
	 @Code [sys].[char](1),
	 @Result [sys].[smallint] OUT
)
AS
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM [dbo].[PersonOfInterest] WHERE [Type] = @Code AND [Deleted] = 0)
	BEGIN
		SET @Result = 1
	END
	ELSE IF (SELECT COUNT (Code) FROM [dbo].[PersonOfInterestType]) = 1
	BEGIN
		SET @Result = 2
	END
	ELSE 
	BEGIN
		DELETE [dbo].[PersonOfInterestTypePermission] WHERE [CodePersonOfInterestType] = @Code
		
		UPDATE [dbo].[PersonOfInterest] SET [Type] = NULL WHERE [Type] = @Code AND [Deleted] = 1 

		DELETE [dbo].[PersonOfInterestType] WHERE [Code] = @Code
		SET @Result = 0
	END
END

/****** Object:  Procedure [dbo].[SetUserCreatedAtKioskMode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetUserCreatedAtKioskMode]
	@IdUser int
AS
BEGIN
	
	UPDATE [dbo].[User]
	SET [CreatedAtKioskMode] = 1
	WHERE [Id] = @IdUser

END

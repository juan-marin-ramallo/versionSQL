/****** Object:  Procedure [dbo].[DeleteUserDashboardSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 21/10/19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUserDashboardSection]
	 @Id [sys].[INT]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IdUser [sys].[INT]
	DECLARE @OldPosition [sys].[INT]

	SELECT @IdUser = IdUser, @OldPosition = Position 
	FROM dbo.[UserDashboardSection]
	WHERE Id = @Id

	UPDATE dbo.[UserDashboardSection]
	SET Position = Position - 1
	WHERE IdUser = @IdUser AND Position > @OldPosition 

	DELETE [dbo].[UserDashboardSection]
	WHERE Id = @Id
END

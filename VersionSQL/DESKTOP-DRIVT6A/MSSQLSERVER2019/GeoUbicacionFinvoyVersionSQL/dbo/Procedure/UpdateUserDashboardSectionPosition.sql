/****** Object:  Procedure [dbo].[UpdateUserDashboardSectionPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 21/10/19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserDashboardSectionPosition](
	 @Id [sys].[INT]
	,@Position [sys].[SMALLINT]
) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IdUser [sys].[INT]
	DECLARE @OldPosition [sys].[INT]

	SELECT @IdUser = IdUser, @OldPosition = Position 
	FROM dbo.[UserDashboardSection]
	WHERE Id = @Id

	--IF @OldPosition > @Position
	--BEGIN
	--	UPDATE dbo.[UserDashboardSection]
	--	SET Position = Position + 1
	--	WHERE IdUser = @IdUser AND Position >= @Position 
	--END
	--ELSE IF @OldPosition < @Position
	--BEGIN
	--	UPDATE dbo.[UserDashboardSection]
	--	SET Position = Position - 1
	--	WHERE IdUser = @IdUser AND Position < @Position 

	--	SET @Position = @Position - 1
	--END
END

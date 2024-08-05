/****** Object:  Procedure [dbo].[SaveUserDashboardSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 21/10/19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserDashboardSection](
	 @IdUser [sys].[INT]
	,@IdDashboardSection [sys].[INT]
	,@Size [sys].[SMALLINT]
	,@IdDateRange [sys].[SMALLINT] = NULL
	,@Id [sys].[INT] OUT
) 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Position [sys].[INT] = (SELECT MAX (Position) FROM dbo.[UserDashboardSection] WHERE IdUser = @IdUser)
	IF @Position IS NULL
	BEGIN 
		SET @Position = 0
	END ELSE
	BEGIN
		SET @Position = @Position + 1
	END

	INSERT INTO [dbo].[UserDashboardSection]
           ([IdUser]
           ,[IdDashboardSection]
           ,[Size]
           ,[Position]
           ,[IdDateRange])
     VALUES
           (@IdUser
           ,@IdDashboardSection
           ,@Size
           ,@Position
           ,@IdDateRange)

	SET @Id = SCOPE_IDENTITY()
END

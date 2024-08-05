/****** Object:  Procedure [dbo].[UpdateUserDashboardSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 21/10/19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserDashboardSection](
	 @Id [sys].[INT]
	,@Size [sys].[SMALLINT]
	,@IdDateRange [sys].[SMALLINT]
	,@IdDashboardSection [sys].[INT]
) AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[UserDashboardSection]
	SET  [Size] = @Size
        ,[IdDateRange] = @IdDateRange
		,[IdDashboardSection] = @IdDashboardSection
	WHERE Id = @Id
END

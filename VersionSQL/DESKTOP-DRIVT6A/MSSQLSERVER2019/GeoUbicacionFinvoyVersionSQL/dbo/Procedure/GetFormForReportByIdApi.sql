/****** Object:  Procedure [dbo].[GetFormForReportByIdApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFormForReportByIdApi]
	 @Id [sys].[int]
AS
BEGIN

	SELECT		F.[Id], F.[Name], F.[Deleted], F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate], F.[OneTimeAnswer],
				F.[IdFormCategory]

	FROM		[dbo].[Form] F
				LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
	
	WHERE		F.[Id] = @Id

END

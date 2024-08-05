/****** Object:  Procedure [dbo].[GetFormById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 02/06/2015
-- Description:	SP para obtener un formulario a partir de su id
-- =============================================

CREATE PROCEDURE [dbo].[GetFormById] 
	@Id [sys].[int]
AS
BEGIN
	SELECT		F.[Id], F.[Name], F.[Description], F.[IsWeighted], U.[Id] AS IdUser, 
				U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date], F.[Deleted], F.[DeletedDate], F.[IdFormCategory], 
				FC.[Name] AS FormCategoryName, F.[OneTimeAnswer], F.[CompleteMultipleTimes],
        F.[StartDate], F.[EndDate], F.[NonPointOfInterest], F.[IsFormPlus]
	
	FROM		[dbo].[Form] F
				INNER JOIN [dbo].[User] U ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
	
	WHERE		F.[Id] = @Id
	
	GROUP BY	F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[DeletedDate], F.[NonPointOfInterest], 
				F.[IdFormCategory], FC.[Name], F.[OneTimeAnswer], F.[CompleteMultipleTimes], F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate], F.[IsFormPlus]
END

/****** Object:  Procedure [dbo].[GetCompletedFormsEngage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/02/2018
-- Description:	SP para obtener los formularios completados ENGAGE SYNC
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedFormsEngage]
	
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
AS
BEGIN

	SELECT		F.[Id], F.[Name], F.[IsWeighted], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date], F.[Deleted], F.[DeletedDate], COUNT(1) AS CompletedForms
	
	FROM		[dbo].[Form] F
				INNER JOIN [dbo].[User] U ON F.[IdUser] = U.[Id]
				INNER JOIN [dbo].[CompletedForm] CF ON F.[Id] = CF.[IdForm]
				LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
	
	WHERE		(Tzdb.IsGreaterOrSameSystemDate(CF.[Date], @DateFrom) = 1 AND Tzdb.IsGreaterOrSameSystemDate(CF.[Date], @DateTo) = 1)
	
	GROUP BY	F.[Id], F.[Name], F.[IsWeighted], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[DeletedDate], 
				F.[IdFormCategory], FC.[Name]
	
	ORDER BY	F.[Date] desc
END

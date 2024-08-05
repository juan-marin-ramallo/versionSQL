/****** Object:  Procedure [dbo].[GetFiles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 30/09/2015
-- Description:	SP para obtener tamaño total de los archivos subidos
-- =============================================
CREATE PROCEDURE [dbo].[GetFiles]

 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdUser [sys].[varchar](1000) = NULL
	,@PersonOfInterestIds [sys].[varchar](MAX) = NULL
AS
BEGIN
	SELECT		F.[Id], F.[FileName] AS Name, F.[Url], F.[Date], F.[IdUser], F.[Title],
				U.[Name] AS UserName, U.[LastName] AS UserLastName, F.[Deleted]
	FROM		[dbo].[File] F WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[FilePersonOfInterest] FP WITH (NOLOCK) ON FP.[IdFile] = F.[Id] 
				LEFT JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = FP.[IdPersonOfInterest]
	WHERE		((@DateFrom IS NULL) OR (@DateTo IS NULL) OR (CAST(Tzdb.FromUtc(F.[Date]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND
				((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](FP.[IdPersonOfInterest], @PersonOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
				AND F.[Deleted] = 0
	GROUP BY	F.[Id], F.[FileName], F.[Url], F.[Date], F.[IdUser],U.[Name], U.[LastName], F.[Title], F.[Deleted]
	ORDER BY	[Date] desc
END

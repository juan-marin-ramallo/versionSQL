/****** Object:  Procedure [dbo].[GetFilesByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 25/11/2015
-- Description:	SP para obtener los archivos adjuntos creados por un usuario
-- =============================================
CREATE PROCEDURE [dbo].[GetFilesByUser]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdUser [sys].[varchar](1000) = NULL
	,@PersonOfInterestIds [sys].[varchar](MAX) = NULL
	,@ShowOnlyDeletedFiles [sys].[BIT] = NULL
AS
BEGIN
	SELECT		F.[Id], F.[FileName] AS Name, F.[Url], F.[Date], F.[IdUser], F.[Title],
				U.[Name] AS UserName, U.[LastName] AS UserLastName, F.[Deleted]
	FROM		[dbo].[File] F WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[FilePersonOfInterest] FP WITH (NOLOCK) ON FP.[IdFile] = F.[Id] 
				LEFT JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = FP.[IdPersonOfInterest]
	WHERE		((@IdUser = 1) OR (U.[Id] = @IdUser)) AND --USUARIO 1 ES XSEED. Pára que los vea todos
				((@DateFrom IS NULL) OR (@DateTo IS NULL) OR F.[Date] BETWEEN @DateFrom AND @DateTo) AND
				((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](FP.[IdPersonOfInterest], @PersonOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@ShowOnlyDeletedFiles = 0 AND F.[Deleted] = 0) OR (@ShowOnlyDeletedFiles = 1 AND F.[Deleted] = 1))
	GROUP BY	F.[Id], F.[FileName], F.[Url], F.[Date], F.[IdUser],U.[Name], U.[LastName], F.[Title], F.[Deleted]
	ORDER BY	[Date] desc
	end

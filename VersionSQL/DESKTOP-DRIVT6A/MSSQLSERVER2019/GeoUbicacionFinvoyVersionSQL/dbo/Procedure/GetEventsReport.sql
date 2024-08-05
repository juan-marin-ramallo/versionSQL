/****** Object:  Procedure [dbo].[GetEventsReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 11/05/2013
-- Description:	SP para obtener un reporte de eventos
-- =============================================
CREATE PROCEDURE [dbo].[GetEventsReport]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @DateFromTruncated [sys].[date]
	DECLARE @DateToTruncated [sys].[date]

	SET @DateFromTruncated = CAST(@DateFrom AS [sys].[date])
	SET @DateToTruncated = CAST(@DateTo AS [sys].[date])


	SELECT		E.[Id], E.[Date], E.[Type], ET.[Description], S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
	FROM		dbo.[Event] E
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id]= E.[IdPersonOfInterest]
				INNER JOIN [dbo].[EventTypeTranslated] ET WITH (NOLOCK) ON ET.[Code] = E.[Type]
	WHERE		CAST([Date] AS [sys].[date]) BETWEEN @DateFromTruncated AND @DateToTruncated AND
				((@Types IS NULL) OR (dbo.CheckVarcharInList(E.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
	ORDER BY	E.[Date] DESC
END

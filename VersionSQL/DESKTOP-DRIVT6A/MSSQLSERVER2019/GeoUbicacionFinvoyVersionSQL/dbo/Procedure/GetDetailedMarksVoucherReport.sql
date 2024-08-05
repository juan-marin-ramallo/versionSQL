/****** Object:  Procedure [dbo].[GetDetailedMarksVoucherReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 16/08/19
-- Description:	SP para obtener un reporte de marcas realizadas
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailedMarksVoucherReport]

	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](1000) = NULL
	,@Types [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@FilterEdits [sys].[bit] = 0
AS
BEGIN

	SELECT M.Id, M.[Date], M.ReceivedDate, M.[Type], MT.[Description] AS MarkType, M.Latitude, M.Longitude
			, S.Id AS PersonId, S.Identifier AS PersonIdentifier, S.[Name] AS PersonName, S.[LastName] AS PersonLastName
			, P.Id AS PointId, P.[Name] AS PointName, ML.Id AS EditId, ML.[Date] AS EditDate, ML.Comment, U.Id AS UserId, U.[Name] AS UserName, U.LastName AS UserLastName
			, IIF(M.[Type] = 'E', ML.EntryDateOld, ML.ExitDateOld) AS PreviousValue, IIF(M.[Type] = 'E', ML.EntryDate, ML.ExitDate) AS NewValue
	FROM dbo.Mark M WITH(NOLOCK)
		INNER JOIN dbo.MarkTypeTranslated MT WITH(NOLOCK) ON M.[Type] = MT.Code
		INNER JOIN dbo.PersonOfInterest S WITH(NOLOCK) ON M.IdPersonOfInterest = S.Id
		LEFT JOIN dbo.PointOfInterest P WITH(NOLOCK) ON M.IdPointOfInterest = P.Id
		LEFT JOIN dbo.MarkLog ML WITH(NOLOCK) ON (M.[Type] = 'E' AND  M.Id = ML.IdEntry) OR (M.[Type] = 'S' AND  M.Id = ML.IdExit)
		LEFT JOIN dbo.[User] U WITH(NOLOCK) ON ML.IdUser = U.Id
	WHERE	(tzdb.[IsBetweenSystemDate](M.[Date], @DateFrom, @DateTo) = 1 
				OR (@FilterEdits = 1 
					AND (tzdb.[IsBetweenSystemDate](M.[ReceivedDate], @DateFrom, @DateTo) = 1 
						OR  EXISTS (SELECT 1 FROM dbo.MarkLog ML2 
									WHERE ((M.[Type] = 'E' AND  M.Id = ML2.IdEntry) OR (M.[Type] = 'S' AND  M.Id = ML2.IdExit)) 
										AND tzdb.[IsBetweenSystemDate](ML2.[Date], @DateFrom, @DateTo) = 1 ))
					)
			)
			AND (@IdDepartments IS NULL OR S.[IdDepartment] IS NULL OR dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)
			AND (@Types IS NULL OR dbo.CheckCharValueInList(S.[Type], @Types) = 1) 
			AND (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1) 
			AND (@IdUser IS NULL OR dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1) 
			AND (@IdUser IS NULL OR dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)
			AND S.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
							FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
							WHERE   M.[Date] >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR M.[Date] < PA.[ToDate]))
	GROUP BY M.Id, M.[Date], M.ReceivedDate, M.[Type], MT.[Description], M.Latitude, M.Longitude
			 , S.Id, S.Identifier, S.[Name], S.[LastName]
			 , P.Id, P.[Name], ML.Id, ML.[Date], ML.Comment, U.Id, U.[Name], U.LastName
			 , IIF(M.[Type] = 'E', ML.EntryDateOld, ML.ExitDateOld), IIF(M.[Type] = 'E', ML.EntryDate, ML.ExitDate)
	ORDER BY S.LastName ASC, M.[Date] ASC, ML.[Date] ASC

END

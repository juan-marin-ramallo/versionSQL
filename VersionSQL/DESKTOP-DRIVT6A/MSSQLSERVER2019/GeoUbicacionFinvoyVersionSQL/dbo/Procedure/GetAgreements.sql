/****** Object:  Procedure [dbo].[GetAgreements]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 29/07/2016
-- Description:	SP para obtener los contratos y acuerdos
-- =============================================
CREATE PROCEDURE [dbo].[GetAgreements]

	 @IdUser [sys].[int] = NULL
	,@AgreementIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@FilterOption [sys].[int] = 2
	,@AllAgreements [sys].[bit] = NULL
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	;WITH Agreements([Id], [Name], [AllPointOfInterest], [CreatedDate], [Deleted], [DeletedDate],
                     [StartDate], [StartDateSystemTruncated], [EndDate], [EndDateSystemTruncated],
                     [Description], [RealFileName], [FileType], [IdUser]) AS
    (
        SELECT  A.[Id], A.[Name], A.[AllPointOfInterest], A.[CreatedDate], A.[Deleted], A.[DeletedDate],
                A.[StartDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(A.[StartDate])), 0) AS StartDateSystemTruncated,
                A.[EndDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(A.[EndDate])), 0) AS EndDateSystemTruncated,
                A.[Description], A.[RealFileName], A.[FileType], A.[IdUser]
	    FROM	[dbo].[Agreement] A WITH (NOLOCK)
        WHERE   ((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1))
                AND ((@AllAgreements = 1) OR (A.[IdUser] = @IdUser))
    )
	
	SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description],A.[RealFileName], A.[FileType]
	
	FROM		Agreements A WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON A.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[AgreementPointOfInterest] AP WITH (NOLOCK) ON A.[Id] = AP.[IdAgreement] 
				LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
	WHERE		((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@FilterOption = 1)
					OR (@FilterOption = 2 AND A.[Deleted] = 0 AND A.[StartDateSystemTruncated] <= @SystemToday AND A.[EndDateSystemTruncated] >= @SystemToday) --ACTIVOS
					OR (@FilterOption = 3 AND A.[Deleted] = 0 AND A.[EndDateSystemTruncated] < @SystemToday) -- VENCIDOS
					OR (@FilterOption = 4 AND A.[Deleted] = 1) -- DESACTIVADOS
					OR (@FilterOption = 5 AND A.[Deleted] = 0 AND A.[StartDateSystemTruncated] > @SystemToday) -- PLANIFICADOS
				)
	
	GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
				A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description], A.[RealFileName], A.[FileType]
	
	
	ORDER BY	A.[CreatedDate] DESC

	--IF @AllAgreements = 1
	--BEGIN
	--	IF @PointOfInterestIds IS NOT NULL
	--	BEGIN

	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description], A.[RealFileName], A.[FileType]
	
	--		FROM		[dbo].[Agreement] A
	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
	--					INNER JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
	--					INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
	
	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
	--		ORDER BY	A.[CreatedDate] DESC
	--	END
	--	ELSE
	--	BEGIN
	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description],A.[RealFileName], A.[FileType]
	
	--		FROM		[dbo].[Agreement] A
	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
	--					LEFT JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
	--					LEFT JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
	
	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
	--		ORDER BY	A.[CreatedDate] DESC
	--	END
 --   END
	--ELSE
	--BEGIN
	--	IF @PointOfInterestIds IS NOT NULL
	--	BEGIN

	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description], A.[RealFileName], A.[FileType]
	
	--		FROM		[dbo].[Agreement] A
	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
	--					INNER JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
	--					INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	--					AND A.[IdUser] = @IdUser
	
	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
	--		ORDER BY	A.[CreatedDate] DESC
	--	END
	--	ELSE
	--	BEGIN
	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description],A.[RealFileName], A.[FileType]
	
	--		FROM		[dbo].[Agreement] A
	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
	--					LEFT JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
	--					LEFT JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
	--					AND A.[IdUser] = @IdUser

	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
	--		ORDER BY	A.[CreatedDate] DESC
	--	END
	--END
END

-- OLD)
-- BEGIN
-- 	DECLARE @SystemToday [sys].[datetime]
-- 	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

-- 	;WITH Agreements([Id], [Name], [AllPointOfInterest], [CreatedDate], [Deleted], [DeletedDate],
--                      [StartDate], [StartDateSystemTruncated], [EndDate], [EndDateSystemTruncated],
--                      [Description], [RealFileName], [FileType], [IdUser]) AS
--     (
--         SELECT  A.[Id], A.[Name], A.[AllPointOfInterest], A.[CreatedDate], A.[Deleted], A.[DeletedDate],
--                 A.[StartDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(A.[StartDate])), 0) AS StartDateSystemTruncated,
--                 A.[EndDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(A.[EndDate])), 0) AS EndDateSystemTruncated,
--                 A.[Description], A.[RealFileName], A.[FileType], A.[IdUser]
-- 	    FROM	[dbo].[Agreement] A WITH (NOLOCK)
--         WHERE   ((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1))
--                 AND ((@AllAgreements = 1) OR (A.[IdUser] = @IdUser))
--     )
	
-- 	SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
-- 					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description],A.[RealFileName], A.[FileType]
	
-- 	FROM		Agreements A WITH (NOLOCK)
-- 				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON A.[IdUser] = U.[Id]
-- 				LEFT JOIN [dbo].[AgreementPointOfInterest] AP WITH (NOLOCK) ON A.[Id] = AP.[IdAgreement] 
-- 				LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
-- 	WHERE		((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
-- 				((@FilterOption = 1)
-- 					OR (@FilterOption = 2 AND A.[Deleted] = 0 AND A.[StartDateSystemTruncated] <= @SystemToday AND A.[EndDateSystemTruncated] >= @SystemToday) --ACTIVOS
-- 					OR (@FilterOption = 3 AND A.[Deleted] = 0 AND A.[EndDateSystemTruncated] < @SystemToday) -- VENCIDOS
-- 					OR (@FilterOption = 4 AND A.[Deleted] = 1) -- DESACTIVADOS
-- 					OR (@FilterOption = 5 AND A.[Deleted] = 0 AND A.[StartDateSystemTruncated] > @SystemToday) -- PLANIFICADOS
-- 				)
	
-- 	GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
-- 				A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description], A.[RealFileName], A.[FileType]
	
	
-- 	ORDER BY	A.[CreatedDate] DESC

-- 	--IF @AllAgreements = 1
-- 	--BEGIN
-- 	--	IF @PointOfInterestIds IS NOT NULL
-- 	--	BEGIN

-- 	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description], A.[RealFileName], A.[FileType]
	
-- 	--		FROM		[dbo].[Agreement] A
-- 	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
-- 	--					INNER JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
-- 	--					INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
-- 	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
-- 	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
	
-- 	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
-- 	--		ORDER BY	A.[CreatedDate] DESC
-- 	--	END
-- 	--	ELSE
-- 	--	BEGIN
-- 	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description],A.[RealFileName], A.[FileType]
	
-- 	--		FROM		[dbo].[Agreement] A
-- 	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
-- 	--					LEFT JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
-- 	--					LEFT JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
-- 	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
-- 	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
	
-- 	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
-- 	--		ORDER BY	A.[CreatedDate] DESC
-- 	--	END
--  --   END
-- 	--ELSE
-- 	--BEGIN
-- 	--	IF @PointOfInterestIds IS NOT NULL
-- 	--	BEGIN

-- 	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description], A.[RealFileName], A.[FileType]
	
-- 	--		FROM		[dbo].[Agreement] A
-- 	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
-- 	--					INNER JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
-- 	--					INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
-- 	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
-- 	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
-- 	--					AND A.[IdUser] = @IdUser
	
-- 	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
-- 	--		ORDER BY	A.[CreatedDate] DESC
-- 	--	END
-- 	--	ELSE
-- 	--	BEGIN
-- 	--		SELECT		A.[Id], A.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate], A.[Description],A.[RealFileName], A.[FileType]
	
-- 	--		FROM		[dbo].[Agreement] A
-- 	--					INNER JOIN [dbo].[User] U ON A.[IdUser] = U.[Id]
-- 	--					LEFT JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
-- 	--					LEFT JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest] AND P.[Deleted] = 0
	
-- 	--		WHERE		((@AgreementIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AgreementIds) = 1)) AND
-- 	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
-- 	--					AND A.[IdUser] = @IdUser

-- 	--		GROUP BY	A.[Id], A.[Name], U.[Id], U.[Name], U.[LastName], A.[AllPointOfInterest],
-- 	--					A.[CreatedDate], A.[Deleted], A.[DeletedDate], A.[StartDate], A.[EndDate],A.[Description],A.[RealFileName], A.[FileType]
	
-- 	--		ORDER BY	A.[CreatedDate] DESC
-- 	--	END
-- 	--END
-- END
